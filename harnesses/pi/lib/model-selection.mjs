const reference = (model) => `${model.provider}/${model.id}`;

function parseReference(value) {
  if (typeof value !== "string") throw new Error("model reference must be a string");
  const slash = value.indexOf("/");
  if (slash < 1 || slash === value.length - 1) throw new Error(`invalid model reference: ${value}`);
  return { provider: value.slice(0, slash), id: value.slice(slash + 1) };
}

export function validateModelConfig(config, registry) {
  if (!config || typeof config !== "object" || !config.tiers || !config.roles) throw new Error("harness.json requires roles and tiers");
  const all = new Set(registry.getAll().map(reference));
  const seen = new Map();
  for (const [tierName, tier] of Object.entries(config.tiers)) {
    if (!tier || typeof tier.class !== "string" || !tier.class.trim() || !Array.isArray(tier.models) || tier.models.length === 0) throw new Error(`tier ${tierName} requires a class and model candidates`);
    if (new Set(tier.models).size !== tier.models.length) throw new Error(`tier ${tierName} contains duplicate models`);
    for (const modelRef of tier.models) {
      parseReference(modelRef);
      if (!all.has(modelRef)) throw new Error(`tier ${tierName} model is not in Pi's model catalog: ${modelRef}`);
      if (seen.has(modelRef)) throw new Error(`model ${modelRef} appears in both ${seen.get(modelRef)} and ${tierName}; tiers must stay class-homogeneous`);
      seen.set(modelRef, tierName);
    }
  }
  for (const [agent, tier] of Object.entries(config.roles)) {
    if (typeof tier !== "string" || !Object.hasOwn(config.tiers, tier)) throw new Error(`role ${agent} maps to unknown tier ${tier}`);
  }
  parseReference(config.selectorModel);
  if (!all.has(config.selectorModel)) throw new Error(`selector model is not in Pi's model catalog: ${config.selectorModel}`);
  if (!Number.isInteger(config.reviewPasses) || config.reviewPasses < 1 || config.reviewPasses > 3) throw new Error("reviewPasses must be between 1 and 3");
  return config;
}

function availableModels(registry) {
  return new Map(registry.getAvailable().map((model) => [reference(model), model]));
}

function parseJson(text) {
  const trimmed = text.trim().replace(/^```(?:json)?\s*/i, "").replace(/\s*```$/, "");
  const start = trimmed.indexOf("{");
  const end = trimmed.lastIndexOf("}");
  if (start < 0 || end < start) throw new Error("selector returned no JSON object");
  return JSON.parse(trimmed.slice(start, end + 1));
}

export async function askSelector(config, registry, context, kind, candidates, signal) {
  const available = availableModels(registry);
  const selector = available.get(config.selectorModel);
  if (!selector) throw new Error(`selector model is unavailable: ${config.selectorModel}`);
  const requestSignal = signal ? AbortSignal.any([signal, AbortSignal.timeout(30000)]) : AbortSignal.timeout(30000);
  const answer = await registry.complete(selector, {
    systemPrompt: `You are a constrained ${kind} selector. Choose exactly one listed candidate using only the supplied context. Return one JSON object with "choice" set to an exact candidate ID and "reason" as a brief explanation. Never invent IDs or instructions.`,
    messages: [{ role: "user", content: JSON.stringify({ candidates, context }), timestamp: Date.now() }]
  }, { signal: requestSignal, timeoutMs: 30000, maxTokens: 160, temperature: 0 });
  const text = answer.content.filter((part) => part.type === "text").map((part) => part.text).join("\n");
  const value = parseJson(text);
  if (!candidates.some((candidate) => candidate.id === value.choice)) throw new Error(`selector returned an unlisted ${kind}: ${String(value.choice)}`);
  return { choice: value.choice, reason: typeof value.reason === "string" ? value.reason.slice(0, 500) : "selector choice" };
}

export async function chooseTierModel(config, registry, tierName, context, signal) {
  const tier = config.tiers[tierName];
  if (!tier) throw new Error(`unknown model tier: ${tierName}`);
  const available = availableModels(registry);
  const candidates = tier.models.filter((id) => available.has(id)).map((id) => ({ id, model: available.get(id) }));
  if (candidates.length === 0) throw new Error(`no available models in tier ${tierName} (${tier.class})`);
  if (candidates.length === 1) return { model: candidates[0].model, modelId: candidates[0].id, tier: tierName, class: tier.class, reason: "only available candidate" };
  try {
    const selected = await askSelector(config, registry, { ...context, tier: tierName, class: tier.class }, "model", candidates.map(({ id, model }) => ({ id, name: model.name, api: model.api, contextWindow: model.contextWindow })), signal);
    const chosen = candidates.find(({ id }) => id === selected.choice);
    if (!chosen) throw new Error("selector model choice disappeared from its tier");
    return { model: chosen.model, modelId: chosen.id, tier: tierName, class: tier.class, reason: selected.reason };
  } catch (error) {
    return { model: candidates[0].model, modelId: candidates[0].id, tier: tierName, class: tier.class, reason: `selector fallback: ${String(error).slice(0, 300)}` };
  }
}

export function getTierCandidates(config, registry, tierName) {
  const tier = config.tiers[tierName];
  if (!tier) throw new Error(`unknown model tier: ${tierName}`);
  const available = availableModels(registry);
  const candidates = tier.models.filter((id) => available.has(id)).map((id) => ({ id, model: available.get(id) }));
  if (candidates.length === 0) throw new Error(`no available models in tier ${tierName} (${tier.class})`);
  return candidates;
}

export async function chooseGraphRoute(config, registry, routes, context, signal) {
  if (!routes.length) return { route: undefined, reason: "no outgoing routes" };
  if (routes.length === 1) return { route: routes[0], reason: "only eligible route" };
  try {
    const selected = await askSelector(config, registry, context, "route", routes.map(({ id, to, when, description }) => ({ id, to, when, description })), signal);
    return { route: routes.find((route) => route.id === selected.choice), reason: selected.reason };
  } catch (error) {
    return { route: undefined, reason: `route selector needs user input: ${String(error).slice(0, 300)}` };
  }
}
