import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { homedir } from "node:os";
import { resolve } from "node:path";
import { classifyToolCall } from "../../lib/permissions.mjs";

function addedDirectories(ctx: any): string[] {
  let dirs: unknown[] = [];
  for (const entry of ctx.sessionManager.getBranch()) {
    if (entry.type === "custom" && entry.customType === "add-dir:state") {
      dirs = (entry.data as { dirs?: unknown[] })?.dirs ?? [];
    }
  }
  return dirs.flatMap((dir: any) => typeof dir?.absolutePath === "string" ? [dir.absolutePath] : []);
}

function trustedReadDirectories(): string[] {
  const home = homedir();
  return [
    resolve(home, ".pi"),
    resolve(home, ".local/share/skills"),
    resolve(home, ".agents/skills"),
    resolve(home, ".codex/skills"),
    resolve(home, "dotfiles/harnesses/pi"),
  ];
}

const policies = [
  { id: "scoped", label: "Scoped access (current + /add-dir roots)", description: "Allow simple operations inside the listed roots; ask outside them or for risky/ambiguous operations." },
  { id: "confirm-changes", label: "Confirm shell commands and edits", description: "Ask before every shell command or file change. Reads still follow the scoped policy." },
  { id: "confirm-all", label: "Confirm every tool call", description: "Ask before every tool call, including reads and orchestration." },
];

function currentPolicy(ctx: any): string {
  let selected = "scoped";
  for (const entry of ctx.sessionManager.getBranch()) {
    if (entry.type === "custom" && entry.customType === "harness:permissions") {
      const id = (entry.data as { policy?: string })?.policy;
      if (policies.some((policy) => policy.id === id)) selected = id;
    }
  }
  return selected;
}

export function registerPermissions(pi: ExtensionAPI) {
  pi.registerCommand("permissions", {
    description: "Choose the permission policy for this Pi session",
    handler: async (_args, ctx: any) => {
      if (!ctx.hasUI) {
        ctx.ui.notify("/permissions requires an interactive UI", "warning");
        return;
      }
      const dirs = addedDirectories(ctx);
      const current = currentPolicy(ctx);
      const choices = policies.map((policy) => `${policy.id === current ? "✓ " : "  "}${policy.label} — ${policy.description}`);
      const selected = await ctx.ui.select(`Permission policy (current: ${current})`, choices);
      if (!selected) return;
      const index = choices.indexOf(selected);
      const policy = policies[index];
      if (!policy) return;
      pi.appendEntry("harness:permissions", { policy: policy.id });
      ctx.ui.notify([
        `Session permission policy set to: ${policy.label}`,
        `Current directory: ${ctx.cwd}`,
        ...(dirs.length ? dirs.map((dir) => `Added directory: ${dir}`) : ["No directories added with /add-dir"]),
        `Trusted read directories: ${trustedReadDirectories().join(", ")}`,
        "This choice is stored in this Pi session.",
      ].join("\n"), "info");
    },
  });

  pi.on("tool_call", async (event: any, ctx: any) => {
    const policy = currentPolicy(ctx);
    if (policy === "confirm-all" || (policy === "confirm-changes" && ["bash", "powershell", "shell", "exec", "exec_command", "write", "edit"].includes(event.toolName))) {
      if (!ctx.hasUI) return { block: true, reason: `Blocked in non-interactive mode by session policy: ${policy}` };
      const accepted = await ctx.ui.confirm("Permission required", `${policy === "confirm-all" ? "Confirm every tool call" : "Confirm shell or file change"}\n${event.toolName}: ${JSON.stringify(event.input).slice(0, 4096)}`);
      if (!accepted) return { block: true, reason: `Blocked by user under session policy: ${policy}` };
      return;
    }
    const verdict = classifyToolCall(event.toolName, {
      ...event.input,
      addedDirs: addedDirectories(ctx),
      readDirs: trustedReadDirectories(),
    }, ctx.cwd);
    if (verdict.action === "allow") return;
    if (!ctx.hasUI) return { block: true, reason: `Blocked in non-interactive mode: ${verdict.reason}` };
    const accepted = await ctx.ui.confirm("Permission required", `${event.toolName}: ${verdict.reason}\n${JSON.stringify(event.input).slice(0, 4096)}`);
    if (!accepted) return { block: true, reason: `Blocked by user: ${verdict.reason}` };
  });
}
