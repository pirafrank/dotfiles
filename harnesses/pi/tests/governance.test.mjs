import test from "node:test";
import assert from "node:assert/strict";
import { mkdtemp, mkdir, writeFile, readFile, symlink, chmod } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { execFileSync } from "node:child_process";
import YAML from "yaml";
import { captureSource } from "../lib/source.mjs";
import { runGovernedGraph, validateContract, assertWriteScope } from "../lib/governance.mjs";
import { validateGraph } from "../lib/graph.mjs";
import { routeTemplate } from "../lib/workflows.mjs";

const agents = new Set(["explorer", "planner", "architect", "implementer", "debugger", "reviewer", "security-reviewer", "verifier"]);
const graph = validateGraph({ name: "proof", entry: "verify", acceptanceCriteria: ["works"], nodes: [{ id: "verify", agent: "verifier", task: "verify", routes: [] }] }, agents);
const source = { root: "/repo", head: "a".repeat(40), fingerprint: "tree-one" };
const contract = { goal: "Make it work", repository: source.root, baseSha: source.head, acceptanceCriteria: ["works"], approvalGates: { scope: true, completion: true } };
const result = { status: "ok", decision: "complete", summary: "checked", evidence: [{ criterion: "works", evidence: "test output" }] };
function setup(overrides = {}) {
  const saves = [];
  const calls = [];
  const options = { graph, runId: "run", contract, contractHash: "contract", configHash: "config", cwd: "/repo", capture: async () => source,
    persist: async (record) => saves.push(structuredClone(record)),
    approve: async (gate) => { calls.push(gate); return { approved: true, actor: "maintainer" }; },
    executeNode: async () => result, ...overrides };
  return { options, saves, calls };
}

test("approval gates persist decisions and bind verifier evidence to the source", async () => {
  const { options, saves, calls } = setup();
  const outcome = await runGovernedGraph(options);
  assert.equal(outcome.status, "complete");
  assert.deepEqual(calls, ["scope", "completion"]);
  assert.equal(outcome.record.approvals.length, 2);
  assert.equal(outcome.state.verify.result.evidence[0].sourceFingerprint, source.fingerprint);
  assert.equal(outcome.state.verify.result.evidence[0].contractHash, "contract");
  assert.ok(saves.some((record) => record.phase === "review"));
  assert.ok(saves.findIndex((record) => record.approvals[0]?.decision === "approved") < saves.findIndex((record) => record.state.verify?.status === "running"));
});

test("declined scope never executes and declined completion resumes without rerunning verifier", async () => {
  const denied = setup({ approve: async () => ({ approved: false }), executeNode: async () => assert.fail("must not execute") });
  assert.equal((await runGovernedGraph(denied.options)).status, "needs_user");
  let executions = 0;
  const pending = setup({ approve: async (gate) => ({ approved: gate === "scope" }), executeNode: async () => { executions++; return result; } });
  const outcome = await runGovernedGraph(pending.options);
  assert.equal(outcome.status, "needs_user");
  assert.equal(outcome.record.phase, "review");
  const resumed = setup({ previous: outcome.record, executeNode: async () => assert.fail("must not rerun") });
  assert.equal((await runGovernedGraph(resumed.options)).status, "complete");
  assert.equal(executions, 1);
  assert.deepEqual(resumed.calls, ["completion"]);
});

test("resume refuses source and contract drift before asking for approval", async () => {
  const previous = (await runGovernedGraph(setup().options)).record;
  for (const change of [{ capture: async () => ({ ...source, fingerprint: "changed" }) }, { contractHash: "changed" }]) {
    await assert.rejects(runGovernedGraph(setup({ previous, ...change, approve: async () => assert.fail("must not ask") }).options), /changed/i);
  }
});

test("source mutation while awaiting human approval invalidates the decision", async () => {
  let current = source;
  const { options } = setup({ capture: async () => current, approve: async () => { current = { ...source, fingerprint: "changed" }; return { approved: true }; } });
  await assert.rejects(runGovernedGraph(options), /Source changed/);
});

test("an interrupted node requires separate human recovery approval", async () => {
  const { options } = setup();
  const previous = (await runGovernedGraph(options)).record;
  previous.phase = "execution";
  previous.state = { verify: { status: "running" } };
  const resumed = setup({ previous, approve: async () => ({ approved: false }), executeNode: async () => assert.fail("must not replay") });
  assert.equal((await runGovernedGraph(resumed.options)).status, "needs_user");
});

test("contract validation consumes the shared schema and enforces execution fields", async () => {
  const root = await mkdtemp(join(tmpdir(), "pi-contract-"));
  const roles = join(root, "roles");
  await mkdir(roles);
  await mkdir(join(root, "schemas"));
  await writeFile(join(root, "schemas/task-contract.schema.json"), JSON.stringify({ type: "object", required: ["goal"], properties: { goal: { type: "string" }, approvalGates: { type: "object" } } }));
  assert.ok(await validateContract(contract, graph, source, roles));
  for (const invalid of [{ ...contract, baseSha: "b".repeat(40) }, { ...contract, acceptanceCriteria: ["other"] }, { ...contract, approvalGates: {} }, { ...contract, goal: "" }]) {
    await assert.rejects(validateContract(invalid, graph, source, roles));
  }
  await writeFile(join(root, "schemas/task-contract.schema.json"), JSON.stringify({ type: "object", required: ["futureField"], properties: { futureField: { type: "string" } } }));
  await assert.rejects(validateContract(contract, graph, source, roles), /Invalid task contract/);
});

test("source snapshots detect tracked, untracked, staged, executable and symlink changes", async () => {
  const root = await mkdtemp(join(tmpdir(), "pi-source-"));
  const git = (...args) => execFileSync("git", args, { cwd: root });
  git("init", "-q");
  git("-c", "user.name=Test", "-c", "user.email=test@example.invalid", "-c", "core.hooksPath=/dev/null", "-c", "commit.gpgsign=false", "commit", "--allow-empty", "-qm", "fixture");
  await writeFile(join(root, "file"), "one");
  const first = await captureSource(root);
  await writeFile(join(root, "file"), "two");
  const second = await captureSource(root);
  assert.notEqual(first.fingerprint, second.fingerprint);
  git("add", "file");
  const staged = await captureSource(root);
  assert.notEqual(second.fingerprint, staged.fingerprint);
  await chmod(join(root, "file"), 0o755);
  const mode = await captureSource(root);
  assert.notEqual(mode.fingerprint, staged.fingerprint);
  await symlink("file", join(root, "link"));
  assert.notEqual((await captureSource(root)).fingerprint, mode.fingerprint);
});

test("portable templates become explicit routes and a declined review stops implementation", async () => {
  const source = YAML.parse(await readFile(new URL("./fixtures/feature.yaml", import.meta.url), "utf8"));
  const routed = validateGraph(routeTemplate(source), agents);
  assert.equal(routed.routed, true);
  assert.equal(routed.nodes.find((node) => node.id === "review").routes[1].to, "needs_user");
  const order = [];
  const { scheduleGraph } = await import("../lib/graph.mjs");
  const state = await scheduleGraph(routed, async (node) => { order.push(node.id); return { status: "ok", decision: node.agent === "reviewer" ? "revise" : undefined }; });
  assert.equal(state._workflow.status, "needs_user");
  assert.ok(!order.includes("verify"));
});


test("write scope detects additions, changes, deletions and forbidden overrides", () => {
  const baseline = { ...source, files: { "src/a": "one", "policy": "original" } };
  assert.doesNotThrow(() => assertWriteScope({ writeAllowed: ["src/**"] }, baseline, { ...baseline, files: { ...baseline.files, "src/a": "two" } }));
  for (const files of [{ ...baseline.files, "other": "new" }, { ...baseline.files, policy: "changed" }, { "src/a": "one" }]) {
    assert.throws(() => assertWriteScope({ writeAllowed: ["src/**"] }, baseline, { ...baseline, files }), /write scope/);
  }
  assert.throws(() => assertWriteScope({ writeAllowed: ["**"], writeForbidden: ["policy"] }, baseline, { ...baseline, files: { ...baseline.files, policy: "changed" } }), /write scope/);
  assert.throws(() => assertWriteScope({ writeAllowed: [] }, baseline, { ...baseline, files: { ...baseline.files, "src/a": "changed" } }), /write scope/);
});

test("verifier source changes cannot produce completion approval", async () => {
  let current = source;
  const { options, calls } = setup({ capture: async () => current, executeNode: async () => { current = { ...source, fingerprint: "changed" }; return result; } });
  const outcome = await runGovernedGraph(options);
  assert.notEqual(outcome.status, "complete");
  assert.deepEqual(calls, ["scope"]);
  assert.ok(outcome.record.integrityFailure);
  await assert.rejects(runGovernedGraph({ ...options, previous: outcome.record }), /integrity failed/);
});


test("a crash after verifier completion resumes directly at human review", async () => {
  const previous = (await runGovernedGraph(setup().options)).record;
  previous.phase = "execution";
  previous.approvals = previous.approvals.filter((item) => item.gate !== "completion");
  const resumed = setup({ previous, executeNode: async () => assert.fail("must not rerun completed verification") });
  assert.equal((await runGovernedGraph(resumed.options)).status, "complete");
  assert.deepEqual(resumed.calls, ["completion"]);
});
