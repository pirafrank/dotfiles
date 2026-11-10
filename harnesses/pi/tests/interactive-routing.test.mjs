import test from "node:test";
import assert from "node:assert/strict";
import { routeInteractive } from "../lib/interactive-routing.mjs";
import { createJiti } from "jiti";

function fixture(answers = []) {
  const models = ["fast", "medium", "frontier", "selector", "backup"].map(id => ({ provider: "test", id, reasoning: true }));
  const config = { selectorModel: "test/selector", tiers: Object.fromEntries(["fast", "medium", "frontier"].map(id => [id, { class: id, models: [`test/${id}`] }])) };
  let calls = 0;
  const registry = { getAvailable: () => models, complete: async () => {
    calls++;
    const answer = answers.shift();
    if (answer instanceof Error) throw answer;
    return { content: [{ type: "text", text: JSON.stringify({ choice: answer }) }] };
  } };
  return { config, registry, models, calls: () => calls };
}
const request = { reason: "user", messages: [{ role: "user", content: "Help with this task" }] };

for (const tier of ["fast", "medium", "frontier"]) test(`routes a prompt to ${tier}`, async () => {
  const f = fixture([tier]);
  assert.equal((await routeInteractive(f.config, f.registry, request)).model.id, tier);
});
for (const answer of [new Error("offline"), "invented-tier"]) test(`medium fallback on ${answer}`, async () => {
  const f = fixture([answer]);
  assert.equal((await routeInteractive(f.config, f.registry, request)).model.id, "medium");
});
test("failed physical selection chooses first available candidate", async () => {
  const f = fixture(["medium", new Error("timeout")]);
  f.config.tiers.medium.models.push("test/backup");
  assert.equal((await routeInteractive(f.config, f.registry, request)).model.id, "medium");
});
test("unavailable medium fails clearly when classification fails", async () => {
  const f = fixture([new Error("offline")]);
  f.models.splice(1, 1);
  await assert.rejects(routeInteractive(f.config, f.registry, request), /no available models in tier medium/);
});
for (const reason of ["continuation", "retry", "direct"]) test(`${reason} preserves physical dispatch without classification`, async () => {
  const f = fixture();
  const previous = { model: f.models[2], thinkingLevel: "high" };
  assert.deepEqual(await routeInteractive(f.config, f.registry, { ...request, reason, previous }), previous);
  assert.equal(f.calls(), 0);
});
test("cancellation propagates", async () => {
  const f = fixture();
  await assert.rejects(routeInteractive(f.config, f.registry, { ...request, signal: AbortSignal.abort() }), { name: "AbortError" });
});
test("extension registers virtual model and leaves delegates on physical defaults", async () => {
  const register = (await createJiti(import.meta.url).import("../extensions/interactive-router/index.ts")).default;
  let definition, handler, changed = false;
  register({ registerVirtualModel: value => definition = value, on: (_event, value) => handler = value, setModel: async () => changed = true });
  assert.equal(definition.provider + "/" + definition.id, "harness/auto");
  await handler({ reason: "startup" }, { hasUI: false });
  assert.equal(changed, false);
  await handler({ reason: "resume" }, { hasUI: true });
  assert.equal(changed, false);
  const model = { provider: "harness", id: "auto" };
  const ctx = { hasUI: true, model: { provider: "openai-codex", id: "gpt-6-luna" }, modelRegistry: { find: () => model }, sessionManager: { getBranch: () => [{ type: "model_change" }] } };
  await handler({ reason: "startup" }, ctx);
  assert.equal(changed, true);
  changed = false;
  await handler({ reason: "startup" }, { ...ctx, sessionManager: { getBranch: () => [{ type: "message" }] } });
  assert.equal(changed, false);
});
