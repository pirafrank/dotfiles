import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { expandAlias, parseAliases, wrapAliasSubmit } from "../extensions/aliases/aliases.mjs";

test("configured exit alias reaches the quit command with either spelling", () => {
  const aliases = parseAliases(JSON.parse(readFileSync(new URL("../extensions/aliases/aliases.json", import.meta.url), "utf8")));
  assert.equal(expandAlias("exit", aliases), "/quit");
  assert.equal(expandAlias(" /exit ", aliases), "/quit");
  assert.equal(expandAlias("/quit", aliases), "/quit");
  assert.equal(expandAlias("please exit", aliases), "please exit");
  assert.equal(expandAlias("exiting", aliases), "exiting");
});

test("aliases forward arguments and expand only once", () => {
  const aliases = parseAliases({ model: "m", m: "pick" });
  assert.equal(expandAlias("/m provider/model", aliases), "/model provider/model");
  assert.equal(expandAlias("pick provider/model", aliases), "/m provider/model");
  assert.equal(expandAlias("", aliases), "");
});

test("invalid configuration fails with actionable errors", () => {
  for (const config of [null, [], "quit", { quit: 1 }, { quit: "" }, { "/quit": "exit" }, { quit: "exit now" }]) {
    assert.throws(() => parseAliases(config), /Alias/);
  }
  assert.throws(() => parseAliases({ quit: "x", model: "x" }), /Duplicate alias/);
});

test("submit wrapper survives Pi assigning and reassigning the handler", () => {
  const editor = wrapAliasSubmit({}, parseAliases({ quit: "exit" }));
  const received = [];
  editor.onSubmit = function (text) { assert.equal(this, editor); received.push(text); };
  editor.onSubmit("/exit");
  editor.onSubmit = (text) => received.push(`new:${text}`);
  editor.onSubmit("exit");
  assert.deepEqual(received, ["/quit", "new:/quit"]);
});
