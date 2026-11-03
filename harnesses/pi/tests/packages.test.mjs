import test from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { validatePackages } from "../lib/packages.mjs";

test("accepts exact scoped and unscoped specs and rejects ranges or trailing garbage", () => {
  for (const spec of ["npm:@scope/name@1.2.3", "npm:name@1.2.3-beta.1"]) assert.deepEqual(validatePackages({ version: 1, packages: [spec] }, { packages: [spec] }), [spec]);
  for (const spec of ["npm:@scope/name", "npm:name@^1.2.3", "npm:name@1.2.3junk", "npm:name@1.2.3/path", "git:repo"]) assert.throws(() => validatePackages({ version: 1, packages: [spec] }, { packages: [spec] }));
});
test("rejects runtime drift and duplicate entries", () => {
  assert.throws(() => validatePackages({ version: 1, packages: [] }, { packages: ["npm:extra@1.0.0"] }), /differ/);
  assert.throws(() => validatePackages({ version: 1, packages: ["npm:x@1.0.0", "npm:x@1.0.0"] }, { packages: [] }), /duplicate/);
});
test("committed runtime declarations match the approved manifest", () => {
  const load = (name) => JSON.parse(readFileSync(new URL(`../${name}`, import.meta.url), "utf8"));
  validatePackages(load("packages.lock.json"), load("settings.json"));
});
