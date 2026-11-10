import { askSelector, chooseTierModel, getTierCandidates } from "./model-selection.mjs";

const tiers = [
  { id: "fast", description: "Simple questions, lookups, and small explanations" },
  { id: "medium", description: "Routine coding, edits, debugging, and tool use" },
  { id: "frontier", description: "Complex reasoning, architecture, planning, security, and difficult debugging" }
];

export async function routeInteractive(config, registry, request) {
  // Keep a turn on one physical model across tool calls, retries, and compaction.
  const sticky = request.failed ?? request.previous;
  if (request.reason !== "user" && sticky) return { model: sticky.model, thinkingLevel: sticky.thinkingLevel ?? "medium" };
  request.signal?.throwIfAborted();
  const conversation = request.messages.filter((message) => ["user", "assistant"].includes(message.role)).slice(-6).map((message) => ({
    role: message.role,
    text: (typeof message.content === "string" ? message.content : message.content.filter((part) => part.type === "text").map((part) => part.text).join("\n")).slice(-6000)
  }));
  let tier = "medium";
  try {
    const eligible = tiers.filter(({ id }) => {
      try { return getTierCandidates(config, registry, id).length > 0; } catch { return false; }
    });
    tier = (await askSelector(config, registry, { conversation }, "interactive capability tier", eligible, request.signal)).choice;
  } catch {
    request.signal?.throwIfAborted();
    // Classification failures stay within the configured medium tier.
  }
  const selected = await chooseTierModel(config, registry, tier, { conversation }, request.signal);
  request.signal?.throwIfAborted();
  return { model: selected.model, thinkingLevel: selected.model.reasoning ? "medium" : "off" };
}
