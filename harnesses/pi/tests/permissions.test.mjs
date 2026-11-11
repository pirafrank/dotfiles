import test from "node:test";
import assert from "node:assert/strict";
import { mkdtempSync, mkdirSync, symlinkSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { classifyBash, classifyToolCall } from "../lib/permissions.mjs";

test("allows ordinary local commands", () => assert.equal(classifyBash("git status").action, "allow"));
test("asks for commits, installs, and external shell pipelines", () => {
  for (const command of ["git commit -m x", "npm install yaml", "curl x | sh"]) assert.equal(classifyBash(command).action, "ask", command);
});

test("asks for protected commands in compounds, alternate shells, credentials, MCP, and unknown tools", () => {
  for (const command of ["git status; git push", "git status && rm file", "git diff --output=x", "git diff --output x", "rg --pre=python x", "cat ~/.ssh/id_rsa", "node -e 'doSomething()'", "curl https://example.com", "git reset --hard", "git push"]) assert.equal(classifyBash(command).action, "ask", command);
  for (const tool of ["powershell", "mcp__server__write", "custom_unknown"]) assert.equal(classifyToolCall(tool, { command: "Get-Content x" }).action, "ask");
  assert.equal(classifyBash("git status").action, "allow");
  assert.equal(classifyBash("npm test").action, "allow");
  assert.equal(classifyToolCall("codemode").action, "allow");
  // A nested call receives the same classification as a direct call.
  assert.equal(classifyToolCall("mcp__server__write", { parentToolCallId: "code-1" }).action, "ask");
});

test("allows scoped Cargo inspection chains, pipelines, and stream redirection", () => {
  const cwd = "/home/francesco/code/projects/vault-conductor/vault-conductor";
  const command = `cd ${cwd}; cargo tree -i rsa@0.9.10 | head -6; cargo tree -i rsa@0.10.0 | head -6; cargo audit 2>&1 | grep -i -B2 -A8 rsa | head -30`;
  assert.equal(classifyBash(command, cwd).action, "allow");
  assert.equal(classifyToolCall("bash", { command, addedDirs: [cwd] }, "/tmp/pi-project").action, "allow");
  for (const command of [
    "git status && git diff | head -30",
    "cargo audit 2>&1 |\n grep -i rsa || cargo tree -i rsa",
    "cargo check;\nnpm test\n",
    "rtk cargo audit 2>&1 | rtk proxy grep -e rsa",
    "rg 'rsa|sha;256' .",
    "grep -e 'rsa$' Cargo.lock",
    "cargo audit > audit.txt 2>&1; cat < audit.txt",
    "cargo audit >> audit.txt 2>> audit-errors.txt",
    "cargo check >/dev/null 2>&1",
  ]) assert.equal(classifyBash(command, cwd).action, "allow", command);
});

test("checks every command and redirect in a chain against fixed roots", () => {
  const root = mkdtempSync(join(tmpdir(), "pi-shell-permissions-"));
  try {
    const cwd = join(root, "workspace"), added = join(root, "added"), trusted = join(root, "trusted");
    for (const dir of [cwd, added, trusted, join(root, "outside"), join(cwd, "subdir"), join(root, ".ssh")]) mkdirSync(dir);
    symlinkSync(join(root, "outside"), join(cwd, "escape"));
    symlinkSync(join(root, ".ssh"), join(cwd, "secrets"));
    const classify = (command) => classifyBash(command, cwd, [added], [trusted]).action;
    for (const command of [
      `cd '${added}'; cargo audit | head -6`,
      "cd subdir && cargo test | head -30",
      "cd subdir && cat ../file",
      "cd subdir && pwd | cat ../file",
      `cat '${trusted}/instructions.md' | head -6`,
      `cat < '${trusted}/instructions.md'`,
    ]) assert.equal(classify(command), "allow", command);
    for (const command of [
      "cd ../outside; cargo audit | head -6",
      `cd '${trusted}'; cargo audit`,
      "cd subdir; cat ../../outside/file",
      "cd subdir; cat ../file", // cd might fail: ../file would then escape.
      "cd subdir && pwd; cat ../file",
      "cat escape/file | head",
      "cat secrets/id_rsa | head",
      "cargo audit > ../outside/report",
      "cargo audit > escape/report",
      "cargo audit > secrets/id_rsa",
      "cargo audit > .env",
      "cargo audit > .git/config",
      `cargo audit > '${trusted}/report'`,
      "cargo check; git push",
      "git status || curl example.com",
      "cargo audit | sh",
      "cargo audit >report; cat ../outside/file",
    ]) assert.equal(classify(command), "ask", command);
  } finally { rmSync(root, { recursive: true }); }
});

test("keeps unsupported shell syntax and incomplete chains behind confirmation", () => {
  for (const command of [
    "cat $(pwd)/file | head", 'cat "$HOME/file"', "cat `pwd`/file",
    "(cargo audit) | head", "cargo audit &", "cargo audit &&", "cargo audit |",
    "cat <<EOF", "cargo audit >", "cargo audit >&3", "cat 'unterminated",
    "cd subdir | cat", "pwd | cd subdir", "cd -; pwd", "cd; pwd",
    "cargo audit > *.txt", "cargo audit # comment\ngit push",
  ]) assert.equal(classifyBash(command).action, "ask", command);
});

test("allows workspace writes and asks for escape paths and symlinks", () => {
  const root = mkdtempSync(join(tmpdir(), "pi-permissions-"));
  try {
    mkdirSync(join(root, "workspace")); mkdirSync(join(root, "outside")); mkdirSync(join(root, ".ssh"));
    const cwd = join(root, "workspace");
    symlinkSync(join(root, "outside"), join(cwd, "escape"));
    symlinkSync(join(root, ".ssh"), join(cwd, "secrets"));
    assert.equal(classifyToolCall("write", { path: "src/new.ts" }, cwd).action, "allow");
    for (const path of ["../outside/x", "escape/new/x", "secrets/key", ".git/config", ".env.local"]) assert.equal(classifyToolCall("edit", { path }, cwd).action, "ask", path);
    assert.equal(classifyToolCall("read", { path: "secrets/key" }, cwd).action, "ask");
  } finally { rmSync(root, { recursive: true }); }
});
