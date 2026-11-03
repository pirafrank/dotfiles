import { realpathSync } from "node:fs";
import { dirname, isAbsolute, relative, resolve, sep } from "node:path";

const ask = (reason) => ({ action: "ask", reason });
const allow = (reason) => ({ action: "allow", reason });
const credentialPath = /(?:^|[\\/])(?:\.env(?:\.[^\\/]*)?|auth\.json|credentials(?:\.json)?|\.ssh|\.aws|\.gnupg|[^\\/]*\.(?:pem|key))(?:[\\/]|$)/i;

export function classifyBash(command) {
  if (typeof command !== "string" || !command.trim()) return ask("empty or invalid shell command");
  // A conservative allowlist, not a shell parser: compounds and expansions need review.
  if (/[;&|<>\n\r\x60$(){}\\]/.test(command) || credentialPath.test(command) || /(?:^|\s)(?:--(?:exec|pre|pre-glob)|-e|-exec|-delete|--output)(?:\s|=|$)/.test(command)) return ask("compound, credential-access, or ambiguous shell operation");
  const plain = command.trim().replace(/^rtk\s+(?:proxy\s+)?/, "");
  if (/^(?:git\s+(?:status|diff|log|show|ls-files)\b|(?:pwd|ls|cat|head|tail|wc|rg|grep)\b|(?:node|npm|pi|python3|cargo)\s+--version\b)/.test(plain)) {
    if (/\s--(?:output|ext-diff|textconv|no-index)(?:\s|=|$)/.test(plain)) return ask("shell option may execute code or write output");
    return allow("read-only inspection");
  }
  if (/^(?:npm (?:test|run (?:check|test|build|lint))|cargo (?:check|test)|just (?:check|test))$/.test(plain)) return allow("local validation recipe");
  return ask("unclassified shell operation (including mutation, install, or external effects)");
}

function canonicalPath(path) {
  try { return realpathSync(path); }
  catch (error) {
    if (error.code !== "ENOENT") throw error;
    const parent = dirname(path);
    if (parent === path) throw error;
    return resolve(canonicalPath(parent), relative(parent, path));
  }
}

export function classifyToolCall(toolName, input = {}, cwd = process.cwd()) {
  if (["bash", "powershell", "shell", "exec", "exec_command"].includes(toolName)) return toolName === "bash" ? classifyBash(input.command) : ask("alternate shell requires review");
  if (["read", "grep", "find", "ls"].includes(toolName)) {
    if (typeof input.path === "string" && credentialPath.test(input.path)) return ask("credential access");
    if (typeof input.path === "string") {
      try { if (credentialPath.test(canonicalPath(resolve(cwd, input.path)))) return ask("credential access through a symlink"); }
      catch { return ask("cannot resolve read path safely"); }
    }
    return allow("read-only tool");
  }
  if (["write", "edit"].includes(toolName)) {
    if (typeof input.path !== "string" || !input.path || credentialPath.test(input.path)) return ask("missing path or credential write");
    try {
      const target = canonicalPath(resolve(cwd, input.path));
      const local = relative(canonicalPath(cwd), target);
      if (!local || isAbsolute(local) || local === ".." || local.startsWith(".." + sep) || /(?:^|[\\/])\.git(?:[\\/]|$)/.test(target)) return ask("write outside the workspace or into Git state");
      if (credentialPath.test(target)) return ask("credential write through a symlink");
      return allow("workspace file change");
    } catch { return ask("cannot resolve write scope safely"); }
  }
  // Nested calls are classified individually by Pi's tool_call pipeline.
  if (["codemode", "tool_search", "delegate", "graph_create", "graph_run", "graph_status"].includes(toolName)) return allow("owned orchestration tool; nested operations retain permission checks");
  return ask("unknown or MCP tool effects require review");
}
