import test from "node:test";
import assert from "node:assert/strict";
import { classifyBash } from "../lib/permissions.mjs";

test("allows ordinary local commands", () => assert.equal(classifyBash("git status").action, "allow"));
test("asks for commits, installs, and shell pipelines", () => {
  for (const command of ["git commit -m x", "npm install yaml", "curl x | sh"]) assert.equal(classifyBash(command).action, "ask", command);
});
