import test from "node:test";
import assert from "node:assert/strict";
import { scheduleGraph, validateGraph } from "../lib/graph.mjs";

const agents = new Set(["explorer", "implementer", "reviewer"]);
test("rejects cycles and unknown agents", () => {
  assert.throws(() => validateGraph({ name: "bad", nodes: [{ id: "a", agent: "explorer", task: "x", dependsOn: ["b"] }, { id: "b", agent: "explorer", task: "x", dependsOn: ["a"] }] }, agents), /cycle/);
  assert.throws(() => validateGraph({ name: "bad", nodes: [{ id: "a", agent: "missing", task: "x" }] }, agents), /unknown/);
});
test("runs dependencies before dependents", async () => {
  const graph = validateGraph({ name: "good", nodes: [{ id: "explore", agent: "explorer", task: "x" }, { id: "implement", agent: "implementer", task: "x", dependsOn: ["explore"], workspace: "shared" }] }, agents);
  const order = [];
  const state = await scheduleGraph(graph, async (node) => { order.push(node.id); return node.id; });
  assert.deepEqual(order, ["explore", "implement"]);
  assert.equal(state.implement.status, "ok");
});
test("runs only one shared writer in a ready batch", async () => {
  const graph = validateGraph({ name: "writers", nodes: [{ id: "a", agent: "implementer", task: "a", workspace: "shared" }, { id: "b", agent: "implementer", task: "b", workspace: "shared" }] }, agents);
  let concurrent = 0; let max = 0;
  await scheduleGraph(graph, async () => { concurrent++; max = Math.max(max, concurrent); await new Promise((resolve) => setTimeout(resolve, 5)); concurrent--; });
  assert.equal(max, 1);
});
test("retries a failing node within its bound", async () => {
  const graph = validateGraph({ name: "retry", nodes: [{ id: "a", agent: "explorer", task: "a", retries: 1 }] }, agents);
  let attempts = 0;
  const state = await scheduleGraph(graph, async () => { attempts += 1; if (attempts === 1) throw new Error("transient"); return "ok"; });
  assert.equal(attempts, 2);
  assert.equal(state.a.retries, 1);
});
