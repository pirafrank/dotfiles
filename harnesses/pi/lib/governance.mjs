import { readFile, realpath } from "node:fs/promises";
import { dirname, join } from "node:path";
import { Ajv2020 } from "ajv/dist/2020.js";
import { stableHash, scheduleGraph } from "./graph.mjs";
import { assertSource, captureSource } from "./source.mjs";

const executionSchema = JSON.parse(await readFile(new URL("../schemas/task-execution.schema.json", import.meta.url), "utf8"));
const validateExecution = new Ajv2020({ strict: true }).compile(executionSchema);

export async function validateContract(contract, graph, source, rolesDirectory) {
  const sharedSchema = JSON.parse(await readFile(join(dirname(await realpath(rolesDirectory)), "schemas/task-contract.schema.json"), "utf8"));
  const validateShared = new Ajv2020({ strict: true }).compile(sharedSchema);
  if (!validateShared(contract) || !validateExecution(contract)) throw new Error(`Invalid task contract: ${JSON.stringify(validateShared.errors ?? validateExecution.errors)}`);
  for (const pattern of [...(contract.writeAllowed ?? []), ...(contract.writeForbidden ?? [])]) {
    if (pattern !== "**" && (!/^[^*?\\]+(?:\/\*\*)?$/.test(pattern) || pattern.startsWith("/") || pattern.split("/").some((part) => part === "." || part === ".."))) throw new Error("Contract paths must be repository-relative exact paths or directory/** patterns");
  }
  if (contract.repository !== source.root || contract.baseSha !== source.head) throw new Error("Contract repository/baseSha does not match the checkout");
  if (stableHash(contract.acceptanceCriteria) !== stableHash(graph.acceptanceCriteria)) throw new Error("Contract acceptance criteria must exactly match the graph");
  return stableHash({ contract, sharedSchema, executionSchema });
}

export function assertWriteScope(contract, baseline, source) {
  if (source.root !== baseline.root || source.head !== baseline.head) throw new Error("Run changed repository or HEAD outside the approved contract");
  const matches = (path, pattern) => pattern === "**" || path === pattern || (pattern.endsWith("/**") && path.startsWith(pattern.slice(0, -2)));
  const paths = new Set([...Object.keys(baseline.files ?? {}), ...Object.keys(source.files ?? {})]);
  for (const path of paths) {
    if (baseline.files[path] === source.files[path]) continue;
    if ((contract.writeAllowed && !contract.writeAllowed.some((pattern) => matches(path, pattern))) || contract.writeForbidden?.some((pattern) => matches(path, pattern))) throw new Error(`Change outside approved write scope: ${path}`);
  }
}

function integrity(record, check) {
  try { check(); }
  catch (error) { record.integrityFailure = String(error); error.retryable = false; throw error; }
}

// Approval callbacks are supplied only by the interactive host, never model output.
export async function runGovernedGraph({ graph, runId, contract, contractHash, configHash, cwd, executeNode, persist, approve, chooseRoute, signal, previous, capture = captureSource }) {
  let source = await capture(cwd);
  if (previous) {
    if (previous.integrityFailure) throw new Error(`Run integrity failed; reconcile the checkout and create a new run: ${previous.integrityFailure}`);
    if (previous.contractHash !== contractHash || previous.graphHash !== graph.hash || previous.configHash !== configHash) throw new Error("Run contract, graph, or configuration changed; create a new run");
    assertSource(previous.source, source);
  }
  const record = previous ? structuredClone(previous) : { runId, graphHash: graph.hash, configHash, contract, contractHash, baseline: source, source, approvals: [], phase: "scope", state: {} };
  const save = async () => {
    record.source = await capture(cwd);
    record.updatedAt = new Date().toISOString();
    await persist(structuredClone(record));
  };
  const request = async (gate, payload) => {
    const binding = stableHash({ runId, gate, graphHash: graph.hash, contractHash, source: record.source.fingerprint, payload });
    if (record.approvals.some((item) => item.binding === binding && item.decision === "approved")) return true;
    const before = record.source;
    const answer = await approve(gate, { ...payload, binding, source: before, contract, graph });
    assertSource(before, await capture(cwd));
    const accepted = answer?.approved === true;
    record.approvals.push({ gate, binding, sourceFingerprint: before.fingerprint, contractHash, graphHash: graph.hash, decision: accepted ? "approved" : "declined", actor: answer?.actor ?? "unavailable", at: new Date().toISOString() });
    await save();
    return accepted;
  };
  const outcome = (status) => ({ state: record.state, status, record });
  await save();
  if (record.phase === "complete") return outcome("complete");
  if (record.phase === "scope") {
    if (!await request("scope", { goal: contract.goal, acceptanceCriteria: contract.acceptanceCriteria })) return outcome("needs_user");
    record.phase = "execution";
    await save();
  }
  // A crash may occur after the scheduler persisted completion but before the
  // host persisted the review phase. Keep the verified candidate for approval.
  if (record.phase === "execution" && record.state._workflow?.status === "complete") {
    record.phase = "review";
    await save();
  }
  if (record.phase === "execution") {
    if (Object.values(record.state).some((node) => node?.status === "running")) {
      if (!await request("recovery", { reason: "Interrupted work may have partial side effects. Inspect the checkout before authorizing replay." })) return outcome("needs_user");
    }
    record.state = await scheduleGraph(graph, async (node, predecessors, reportProgress) => {
      const before = await capture(cwd);
      integrity(record, () => assertWriteScope(contract, record.baseline, before));
      const result = await executeNode(node, { ...predecessors, contract, acceptanceCriteria: contract.acceptanceCriteria }, reportProgress);
      const after = await capture(cwd);
      integrity(record, () => assertWriteScope(contract, record.baseline, after));
      if (node.agent === "verifier") integrity(record, () => assertSource(before, after));
      return { ...result, sourceFingerprint: after.fingerprint, evidence: result.evidence?.map((item) => ({ ...item, sourceFingerprint: after.fingerprint, contractHash })) };
    }, {
      signal, initialState: record.state, limits: { maxParallel: 1 }, chooseRoute,
      onState: async (state) => { record.state = state; await save(); }
    });
    const status = record.state._workflow?.status ?? (Object.values(record.state).some((node) => node?.status === "failed") ? "failed" : "finished");
    if (status !== "complete") { await save(); return outcome(status); }
    record.phase = "review";
    await save();
  }
  if (record.phase === "review") {
    assertWriteScope(contract, record.baseline, record.source);
    const verified = graph.nodes.some((node) => node.agent === "verifier" && record.state[node.id]?.result?.decision === "complete" && record.state[node.id]?.result?.sourceFingerprint === record.source.fingerprint);
    if (!verified) throw new Error("Source no longer matches verifier evidence; create a new run");
    if (!await request("completion", { state: record.state })) return outcome("needs_user");
    record.phase = "complete";
    await save();
  }
  return outcome("complete");
}
