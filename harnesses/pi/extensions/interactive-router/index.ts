import { readFile } from "node:fs/promises";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { routeInteractive } from "../../lib/interactive-routing.mjs";

export default function registerInteractiveRouter(pi: ExtensionAPI) {
  pi.registerVirtualModel({
    provider: "harness",
    id: "auto",
    name: "Harness Auto",
    thinkingLevels: ["medium"],
    async route(request, ctx) {
      const config = JSON.parse(await readFile(new URL("../../harness.json", import.meta.url), "utf8"));
      return routeInteractive(config, ctx.modelRegistry, request);
    }
  });
  pi.on("session_start", async (event, ctx) => {
    if (!ctx.hasUI || !["startup", "new"].includes(event.reason)) return;
    if (ctx.sessionManager.getBranch().some((entry) => entry.type === "message")) return;
    if (process.argv.some((arg) => arg === "--model" || arg === "--provider" || arg.startsWith("--model=") || arg.startsWith("--provider="))) return;
    const model = ctx.modelRegistry.find("harness", "auto");
    // Respect restored selections and explicit CLI choices. New interactive
    // sessions use auto when starting from the configured physical default.
    if (model && ctx.model?.provider === "openai-codex" && ctx.model.id === "gpt-6-luna") await pi.setModel(model);
  });
}
