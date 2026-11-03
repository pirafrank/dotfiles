import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { classifyToolCall } from "../../lib/permissions.mjs";

export function registerPermissions(pi: ExtensionAPI) {
  pi.on("tool_call", async (event: any, ctx: any) => {
    const verdict = classifyToolCall(event.toolName, event.input, ctx.cwd);
    if (verdict.action === "allow") return;
    if (!ctx.hasUI) return { block: true, reason: `Blocked in non-interactive mode: ${verdict.reason}` };
    const accepted = await ctx.ui.confirm("Permission required", `${event.toolName}: ${verdict.reason}\n${JSON.stringify(event.input).slice(0, 4096)}`);
    if (!accepted) return { block: true, reason: `Blocked by user: ${verdict.reason}` };
  });
}
