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

test("passes predecessor results and persists running and completed states", async () => {
  const graph = validateGraph({ name: "handoff", nodes: [{ id: "a", agent: "explorer", task: "explore" }, { id: "b", agent: "explorer", task: "review", dependsOn: ["a"] }] }, agents);
  const snapshots = [];
  const evidence = { status: "ok", summary: "found implementation" };
  await scheduleGraph(graph, async (node, predecessors) => {
    if (node.id === "b") assert.deepEqual(predecessors, { a: evidence });
    return evidence;
  }, { onState: async (state) => snapshots.push(state) });
  assert.equal(snapshots[0].a.status, "pending");
  assert.ok(snapshots.some((state) => state.a.status === "running"));
  assert.equal(snapshots.at(-1).b.status, "ok");
});

test("failed structured results skip dependents and cancellation prevents launch", async () => {
  const graph = validateGraph({ name: "failed", nodes: [{ id: "a", agent: "explorer", task: "x", retries: 0 }, { id: "b", agent: "explorer", task: "x", dependsOn: ["a"] }] }, agents);
  const state = await scheduleGraph(graph, async () => ({ status: "failed", summary: "no evidence" }));
  assert.equal(state.a.status, "failed");
  assert.equal(state.b.status, "skipped");
  const signal = AbortSignal.abort();
  await scheduleGraph(graph, async () => assert.fail("must not launch"), { signal });
});

test("persistence errors abort scheduling instead of retrying the agent", async () => {
  const graph = validateGraph({ name: "disk", nodes: [{ id: "a", agent: "explorer", task: "x" }] }, agents);
  await assert.rejects(scheduleGraph(graph, async () => assert.fail("must not launch"), { onState: () => { throw new Error("disk full"); } }), /disk full/);
  assert.throws(() => validateGraph({ ...graph, name: "../escape" }, agents), /safe name/);
});

test("routed retries can recover and unmet dependencies stop execution", async () => {
  const source = { name: "routed", entry: "a", nodes: [{ id: "a", agent: "explorer", task: "inspect", retries: 1, routes: [{ id: "stop", to: "needs_user" }] }] };
  let attempts = 0;
  const state = await scheduleGraph(validateGraph(source, agents), async () => {
    if (++attempts === 1) throw new Error("temporary");
    return { status: "ok", summary: "inspected" };
  });
  assert.equal(state.a.status, "ok");
  assert.equal(attempts, 2);
  const dependent = { ...source, nodes: [{ ...source.nodes[0], dependsOn: ["b"] }, { id: "b", agent: "explorer", task: "prerequisite", routes: [{ id: "stop", to: "needs_user" }] }] };
  const blocked = await scheduleGraph(validateGraph(dependent, agents), async () => assert.fail("must not execute"));
  assert.match(blocked._workflow.reason, /unsatisfied dependency/);
});

test("unmatched conditional routes cannot be selected by a model", async () => {
  const graph = validateGraph({ name: "conditions", entry: "a", nodes: [{ id: "a", agent: "explorer", task: "inspect", routes: [{ id: "accept", to: "needs_user", when: { decision: "accept" } }, { id: "revise", to: "replan", when: { decision: "revise" } }] }] }, agents);
  const state = await scheduleGraph(graph, async () => ({ status: "ok", summary: "no decision" }), { chooseRoute: async (routes) => { assert.equal(routes.length, 0); return undefined; } });
  assert.equal(state._workflow.status, "needs_user");
  assert.equal(state._workflow.routeHistory.length, 0);
});
