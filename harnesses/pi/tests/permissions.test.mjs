import test from "node:test";
import assert from "node:assert/strict";
import { mkdtempSync, mkdirSync, symlinkSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { classifyBash, classifyToolCall } from "../lib/permissions.mjs";

test("allows ordinary local commands", () => assert.equal(classifyBash("git status").action, "allow"));
test("asks for commits, installs, and shell pipelines", () => {
  for (const command of ["git commit -m x", "npm install yaml", "curl x | sh"]) assert.equal(classifyBash(command).action, "ask", command);
});

test("asks for compounds, alternate shells, credentials, MCP, and unknown tools", () => {
  for (const command of ["git status; git push", "git status && rm file", "git diff --output=x", "git diff --output x", "rg --pre=python x", "cat ~/.ssh/id_rsa", "node -e 'doSomething()'", "curl https://example.com", "git reset --hard", "git push"]) assert.equal(classifyBash(command).action, "ask", command);
  for (const tool of ["powershell", "mcp__server__write", "custom_unknown"]) assert.equal(classifyToolCall(tool, { command: "Get-Content x" }).action, "ask");
  assert.equal(classifyBash("git status").action, "allow");
  assert.equal(classifyBash("npm test").action, "allow");
  assert.equal(classifyToolCall("codemode").action, "allow");
  // A nested call receives the same classification as a direct call.
  assert.equal(classifyToolCall("mcp__server__write", { parentToolCallId: "code-1" }).action, "ask");
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
