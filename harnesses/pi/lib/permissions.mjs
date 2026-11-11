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

// Parse only the shell constructs whose scope we can follow. Everything else
// still requires confirmation; quoted operators are ordinary argument text.
function shellTokens(command) {
  const tokens = [];
  let word = "", started = false, quote = "";
  const flush = () => {
    if (started) tokens.push({ word });
    word = ""; started = false;
  };
  for (let i = 0; i < command.length; i++) {
    const ch = command[i];
    if (quote) {
      if (ch === quote) quote = "";
      else {
        if (quote === '"' && /[$`\\]/.test(ch)) return null;
        word += ch;
      }
      continue;
    }
    if (ch === "'" || ch === '"') { quote = ch; started = true; continue; }
    if (/[$`(){}\\]/.test(ch)) return null;
    if (ch === "#" && !started) return null;
    if (ch === " " || ch === "\t" || ch === "\r") { flush(); continue; }
    if (";&|<>\n".includes(ch)) {
      // Descriptor duplication changes streams without accessing a file.
      if (ch === ">" && started && /^[012]$/.test(word) && command.slice(i, i + 3).match(/^>&[12]/) &&
          (i + 3 === command.length || /[\s;&|]/.test(command[i + 3]))) {
        word = ""; started = false; i += 2; continue;
      }
      if (ch === "<" || ch === ">") {
        if (started && /^[012]$/.test(word)) { word = ""; started = false; }
        flush();
        let redirect = ch;
        if (ch === ">" && command[i + 1] === ">") { redirect += ">"; i++; }
        if (/[<>&|]/.test(command[i + 1] ?? "")) return null;
        tokens.push({ redirect });
        continue;
      }
      flush();
      let op = ch === "\n" ? ";" : ch;
      if ((ch === "&" || ch === "|") && command[i + 1] === ch) { op += ch; i++; }
      if (op === "&") return null;
      tokens.push({ op });
      continue;
    }
    word += ch; started = true;
  }
  if (quote) return null;
  flush();
  return tokens;
}

function pathArguments(words, cwd) {
  return words.map((word) => word.replace(/^--[^=]+=/, ""))
    .filter((word) => word && (word === ".." || word.includes("/")))
    .map((word) => word.startsWith("~/") ? resolve(process.env.HOME ?? "", word.slice(2)) : resolve(cwd, word));
}

function classifyCommand(words, cwd, writeRoots, readDirs) {
  if (words[0] === "rtk") words = words.slice(words[1] === "proxy" ? 2 : 1);
  const plain = words.join(" ");
  if (!words.length) return ask("empty shell command");
  if (words.some((word) => credentialPath.test(word)) ||
      words.some((word) => /^(?:--(?:exec|pre|pre-glob|output)(?:=|$)|-exec$|-delete$)/.test(word)) ||
      (!/^(?:rg|grep)$/.test(words[0]) && words.includes("-e"))) return ask("credential-access or executable shell option");
  const readOnlyCommand = /^(?:(?:pwd|ls|cat|head|tail|wc|rg|grep|find)\b|git\s+(?:status|diff|log|show|ls-files)\b)/.test(plain);
  const roots = readOnlyCommand ? [...writeRoots, ...readDirs] : writeRoots;
  for (const path of pathArguments(words, cwd)) {
    try {
      if (credentialPath.test(canonicalPath(path))) return ask("credential access through a symlink");
      if (!isWithin(path, roots)) return ask(`path is outside the current or added directories: ${path}`);
    } catch { return ask("cannot resolve shell path safely"); }
  }
  if (/^(?:sudo|su|doas|ssh|scp|sftp|curl|wget|nc|ncat|systemctl|service|mount|umount|mkfs|shutdown|reboot|killall|useradd|userdel|chmod|chown|rm|rmdir|bash|sh|zsh|fish|eval|exec|env|xargs|source)\b/.test(plain) || words[0] === ".") return ask("privileged, destructive, external, or indirect shell operation");
  if (/^(?:git\s+(?:status|diff|log|show|ls-files)\b|(?:pwd|ls|cat|head|tail|wc|rg|grep)\b|(?:node|npm|pi|python3|cargo)\s+--version\b)/.test(plain)) {
    if (words.some((word) => /^--(?:output|ext-diff|textconv|no-index)(?:=|$)/.test(word))) return ask("shell option may execute code or write output");
    return allow("read-only inspection");
  }
  if (/^(?:npm (?:test|run (?:check|test|build|lint))|cargo (?:check|test)|just (?:check|test))$/.test(plain)) return allow("local validation recipe");
  if (/^(?:git\s+(?:add|commit|restore|checkout|switch|merge|rebase|reset|stash|tag|branch|clean|push|pull|fetch|clone)\b|npm\s+(?:install|ci|uninstall|update|pack)\b)/.test(plain)) return ask("Git or package operation can affect state outside the selected directories");
  if (/^[\w./+-]+$/.test(words[0])) return allow("command is scoped to the current or added directories");
  return ask("unclassified shell operation");
}

export function classifyBash(command, cwd = process.cwd(), addedDirs = [], readDirs = []) {
  if (typeof command !== "string" || !command.trim()) return ask("empty or invalid shell command");
  const tokens = shellTokens(command);
  if (!tokens) return ask("unsupported shell syntax or expansion");
  const writeRoots = [cwd, ...addedDirs].map((root) => resolve(root));
  const readRoots = readDirs.map((root) => resolve(root));
  // Track success and failure separately: && runs after a successful cd,
  // while ';' can run even when cd failed. Pipeline stages share their input
  // directory (directory-changing pipeline stages require confirmation).
  let directories = [resolve(cwd)], words = [], redirects = [], previousOp = null;
  let successDirs = directories, failureDirs = directories, pipelineDirs = directories;
  let skippedSuccess = [], skippedFailure = [];
  const unique = (...groups) => [...new Set(groups.flat())];
  for (let i = 0; i <= tokens.length; i++) {
    const token = tokens[i];
    if (token?.redirect) {
      const target = tokens[++i];
      if (typeof target?.word !== "string" || !target.word || /[*?[]/.test(target.word)) return ask("ambiguous redirection target");
      redirects.push({ path: target.word, read: token.redirect === "<" });
      continue;
    }
    if (token && !token.op) { words.push(token.word); continue; }
    if (!words.length) {
      // Newlines can follow a pipe/conditional, or separate list commands.
      if (token?.op === ";") continue;
      if (!token && previousOp === ";") break;
      return ask("incomplete shell command");
    }
    if (previousOp === "|") directories = pipelineDirs;
    else {
      directories = previousOp === "&&" ? successDirs : previousOp === "||" ? failureDirs : unique(successDirs, failureDirs);
      pipelineDirs = directories;
      skippedSuccess = previousOp === "||" ? successDirs : [];
      skippedFailure = previousOp === "&&" ? failureDirs : [];
    }
    let successfulDirs = directories;
    for (const redirect of redirects) {
      for (const dir of directories) {
        const path = redirect.path.startsWith("~/") ? resolve(process.env.HOME ?? "", redirect.path.slice(2)) : resolve(dir, redirect.path);
        if (path === "/dev/null") continue;
        try {
          const target = canonicalPath(path);
          const roots = redirect.read ? [...writeRoots, ...readRoots] : writeRoots;
          if (credentialPath.test(target) || !isWithin(target, roots) || (!redirect.read && /(?:^|[\\/])\.git(?:[\\/]|$)/.test(target))) return ask("redirection accesses a protected path or is outside the allowed directories");
        } catch { return ask("cannot resolve redirection safely"); }
      }
    }
    if (words[0] === "cd") {
      if (previousOp === "|" || token?.op === "|" || words.length !== 2 || words[1].startsWith("-") || !words[1]) return ask("ambiguous directory change");
      const targets = directories.map((dir) => words[1].startsWith("~/") ? resolve(process.env.HOME ?? "", words[1].slice(2)) : resolve(dir, words[1]));
      try {
        if (targets.some((target) => credentialPath.test(canonicalPath(target)) || !isWithin(target, writeRoots))) return ask("directory change is outside the current or added directories, or accesses credentials");
      } catch { return ask("cannot resolve directory change safely"); }
      successfulDirs = targets;
    } else {
      for (const dir of directories) {
        const verdict = classifyCommand(words, dir, writeRoots, readRoots);
        if (verdict.action !== "allow") return verdict;
      }
    }
    successDirs = unique(successfulDirs, skippedSuccess);
    failureDirs = unique(directories, skippedFailure);
    if (unique(successDirs, failureDirs).length > 32) return ask("too many possible shell directories");
    words = []; redirects = []; previousOp = token?.op ?? null;
  }
  return allow("shell commands are scoped to the current or added directories");
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
