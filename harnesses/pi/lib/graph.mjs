import { createHash } from "node:crypto";

export const DEFAULT_LIMITS = Object.freeze({ maxNodes: 12, maxParallel: 3, maxRetries: 1, maxIterations: 2 });
export const stableHash = (value) => createHash("sha256").update(JSON.stringify(value)).digest("hex");

export function validateGraph(graph, knownAgents, limits = DEFAULT_LIMITS) {
  if (!graph || typeof graph.name !== "string" || !Array.isArray(graph.nodes) || graph.nodes.length === 0) throw new Error("graph requires a name and nodes");
  if (graph.nodes.length > limits.maxNodes) throw new Error(`graph exceeds maxNodes (${limits.maxNodes})`);
  const byId = new Map();
  for (const node of graph.nodes) {
    if (!node?.id || !node.agent || !node.task) throw new Error("each node requires id, agent, and task");
    if (byId.has(node.id)) throw new Error(`duplicate node id: ${node.id}`);
    if (!knownAgents.has(node.agent)) throw new Error(`unknown agent: ${node.agent}`);
    if ((node.retries ?? 0) > limits.maxRetries) throw new Error(`node ${node.id} exceeds maxRetries`);
    byId.set(node.id, { ...node, dependsOn: node.dependsOn ?? [], retries: node.retries ?? limits.maxRetries });
  }
  const visiting = new Set(); const visited = new Set();
  const visit = (id, depth = 1) => {
    if (depth > limits.maxNodes) throw new Error("graph exceeds maximum dependency depth");
    if (visiting.has(id)) throw new Error("graph contains a cycle");
    if (visited.has(id)) return;
    visiting.add(id);
    for (const dependency of byId.get(id).dependsOn) { if (!byId.has(dependency)) throw new Error(`node ${id} depends on missing node ${dependency}`); visit(dependency, depth + 1); }
    visiting.delete(id); visited.add(id);
  };
  for (const id of byId.keys()) visit(id);
  return { name: graph.name, nodes: [...byId.values()], hash: stableHash(graph) };
}

export async function scheduleGraph(graph, executeNode, options = {}) {
  const limits = { ...DEFAULT_LIMITS, ...options.limits };
  const states = new Map(graph.nodes.map((node) => [node.id, { status: "pending", retries: 0 }]));
  while ([...states.values()].some((state) => state.status === "pending" || state.status === "running")) {
    const writerRunning = [...states.values()].some((state) => state.status === "running" && state.workspace === "shared");
    const candidates = graph.nodes.filter((node) => {
      const state = states.get(node.id);
      return state.status === "pending" && node.dependsOn.every((id) => states.get(id).status === "ok") && !(node.workspace === "shared" && writerRunning);
    });
    const ready = [];
    for (const node of candidates) {
      if (ready.length >= limits.maxParallel) break;
      if (node.workspace === "shared" && ready.some((candidate) => candidate.workspace === "shared")) continue;
      ready.push(node);
    }
    if (!ready.length) { for (const node of graph.nodes) if (states.get(node.id).status === "pending") states.set(node.id, { status: "skipped", reason: "failed dependency", retries: 0 }); break; }
    await Promise.all(ready.map(async (node) => {
      let retries = 0;
      while (true) {
        states.set(node.id, { status: "running", retries, workspace: node.workspace });
        try { states.set(node.id, { status: "ok", result: await executeNode(node), retries, workspace: node.workspace }); break; }
        catch (error) {
          if (retries >= node.retries) { states.set(node.id, { status: "failed", error: String(error), retries, workspace: node.workspace }); break; }
          retries += 1;
        }
      }
    }));
  }
  return Object.fromEntries(states);
}
