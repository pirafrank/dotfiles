import { realpathSync } from "node:fs";
import { dirname, isAbsolute, relative, resolve, sep } from "node:path";

const ask = (reason) => ({ action: "ask", reason });
const allow = (reason) => ({ action: "allow", reason });
const credentialPath = /(?:^|[\\/])(?:\.env(?:\.[^\\/]*)?|auth\.json|credentials(?:\.json)?|\.ssh|\.aws|\.gnupg|[^\\/]*\.(?:pem|key))(?:[\\/]|$)/i;

function isWithin(path, roots) {
  return roots.some((root) => {
    const local = relative(canonicalPath(root), canonicalPath(path));
    return local === "" || (!isAbsolute(local) && local !== ".." && !local.startsWith(".." + sep));
  });
}

function pathArguments(command, cwd) {
  // Shell syntax is deliberately rejected before this lightweight token scan.
  // This is a scope check, not a shell parser.
  return command.match(/(?:"[^"]*"|'[^']*'|\S+)/g)?.map((token) => token.replace(/^["']|["']$/g, ""))
    .filter((token) => token && (token.startsWith("/") || token === ".." || token.startsWith("../") || token.includes("/../") || token.startsWith("~/") || token.startsWith("./") || token.includes("/")))
    .map((token) => token.startsWith("~/") ? resolve(process.env.HOME ?? "", token.slice(2)) : resolve(cwd, token));
}

export function classifyBash(command, cwd = process.cwd(), addedDirs = [], readDirs = []) {
  if (typeof command !== "string" || !command.trim()) return ask("empty or invalid shell command");
  if (command.includes("&&")) {
    const parts = command.split("&&").map((part) => part.trim());
    const safeReadOnly = /^(?:rtk\s+(?:proxy\s+)?)?(?:pwd|ls|cat|head|tail|wc|rg|grep|find|git\s+(?:status|diff|log|show|ls-files))\b[^;&|<>\n\r\x60$(){}\\]*$/;
    if (parts.length > 1 && parts.every((part) => safeReadOnly.test(part))) {
      const results = parts.map((part) => classifyBash(part, cwd, addedDirs, readDirs));
      const denied = results.find((result) => result.action !== "allow");
      return denied ?? allow("chained read-only inspection commands");
    }
  }
  // A conservative allowlist, not a shell parser: compounds and expansions need review.
  if (/[;&|<>\n\r\x60$(){}\\]/.test(command) || credentialPath.test(command) || /(?:^|\s)(?:--(?:exec|pre|pre-glob)|-e|-exec|-delete|--output)(?:\s|=|$)/.test(command)) return ask("compound, credential-access, or ambiguous shell operation");
  const plain = command.trim().replace(/^rtk\s+(?:proxy\s+)?/, "");
  const writeRoots = [cwd, ...addedDirs].map((root) => resolve(root));
  const readOnlyCommand = /^(?:(?:pwd|ls|cat|head|tail|wc|rg|grep|find)\b|git\s+(?:status|diff|log|show|ls-files)\b)/.test(plain);
  const roots = readOnlyCommand ? [...writeRoots, ...readDirs.map((root) => resolve(root))] : writeRoots;
  const outside = pathArguments(plain, cwd).find((path) => {
    try { return !isWithin(path, roots); } catch { return true; }
  });
  if (outside) return ask(`path is outside the current or added directories: ${outside}`);
  if (/^(?:sudo|su|doas|ssh|scp|sftp|curl|wget|nc|ncat|systemctl|service|mount|umount|mkfs|shutdown|reboot|killall|useradd|userdel|chmod|chown)\b/.test(plain)) return ask("privileged or external/system operation");
  if (/^(?:git\s+(?:status|diff|log|show|ls-files)\b|(?:pwd|ls|cat|head|tail|wc|rg|grep)\b|(?:node|npm|pi|python3|cargo)\s+--version\b)/.test(plain)) {
    if (/\s--(?:output|ext-diff|textconv|no-index)(?:\s|=|$)/.test(plain)) return ask("shell option may execute code or write output");
    return allow("read-only inspection");
  }
  if (/^(?:npm (?:test|run (?:check|test|build|lint))|cargo (?:check|test)|just (?:check|test))$/.test(plain)) return allow("local validation recipe");
  if (/^(?:git\s+(?:add|commit|restore|checkout|switch|merge|rebase|reset|stash|tag|branch|clean|push|pull|fetch|clone)\b|npm\s+(?:install|ci|uninstall|update|pack)\b)/.test(plain)) return ask("Git or package operation can affect state outside the selected directories");
  if (/^[\w./+-]+(?:\s+[^;&|<>\n\r\x60$(){}\\]+)*$/.test(plain)) return allow("command is scoped to the current or added directories");
  return ask("unclassified shell operation");
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
  if (["bash", "powershell", "shell", "exec", "exec_command"].includes(toolName)) return toolName === "bash" ? classifyBash(input.command, cwd, input.addedDirs ?? [], input.readDirs ?? []) : ask("alternate shell requires review");
  const roots = [cwd, ...(input.addedDirs ?? [])].map((root) => resolve(root));
  const readRoots = [...roots, ...(input.readDirs ?? []).map((root) => resolve(root))];
  if (["read", "grep", "find", "ls"].includes(toolName)) {
    if (typeof input.path === "string" && credentialPath.test(input.path)) return ask("credential access");
    if (typeof input.path === "string") {
      try {
        const target = canonicalPath(resolve(cwd, input.path));
        if (credentialPath.test(target)) return ask("credential access through a symlink");
        if (!isWithin(target, readRoots)) return ask("read outside the current, added, or trusted Pi directories");
      }
      catch { return ask("cannot resolve read path safely"); }
    }
    return allow("read-only tool");
  }
  if (["write", "edit"].includes(toolName)) {
    if (typeof input.path !== "string" || !input.path || credentialPath.test(input.path)) return ask("missing path or credential write");
    try {
      const target = canonicalPath(resolve(cwd, input.path));
      if (!isWithin(target, roots) || /(?:^|[\\/])\.git(?:[\\/]|$)/.test(target)) return ask("write outside the current or added directories, or into Git state");
      if (credentialPath.test(target)) return ask("credential write through a symlink");
      return allow("workspace file change");
    } catch { return ask("cannot resolve write scope safely"); }
  }
  // Nested calls are classified individually by Pi's tool_call pipeline.
  if (["codemode", "tool_search", "delegate", "graph_plan", "graph_create", "graph_run", "graph_resume", "graph_status"].includes(toolName)) return allow("owned orchestration tool; nested operations retain permission checks");
  return ask("unknown or MCP tool effects require review");
}
