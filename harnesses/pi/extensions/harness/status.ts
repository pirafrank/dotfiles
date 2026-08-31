import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export function registerStatus(pi: ExtensionAPI) {
  pi.on("session_start", async (_event: any, ctx: any) => { ctx.ui.setStatus("pirafrank-harness", "harness: ready"); });
}
