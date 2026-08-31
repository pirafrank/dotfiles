import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { registerDelegate } from "./delegate.ts";
import { registerGraph } from "./graph.ts";
import { registerPermissions } from "./permissions.ts";
import { registerStatus } from "./status.ts";

export default function registerHarness(pi: ExtensionAPI) {
  registerPermissions(pi);
  registerDelegate(pi);
  registerGraph(pi);
  registerStatus(pi);
}
