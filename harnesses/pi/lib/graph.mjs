import { createHash } from "node:crypto";

export const DEFAULT_LIMITS = Object.freeze({ maxNodes: 12, maxParallel: 3, maxRetries: 1, maxIterations: 2 });
const TERMINAL_ROUTES = new Set(["needs_user", "complete", "replan"]);
const STATUSES = new Set(["ok", "failed", "cancelled", "timeout"]);
const DECISIONS = new Set(["accept", "revise", "replan", "complete", "needs_user"]);
export const stableHash = (value) => createHash("sha256").update(JSON.stringify(value)).digest("hex");

function hasAcceptanceEvidence(result, criteria) {
  if (!Array.isArray(result.evidence)) return false;
  const proven = new Set(result.evidence.filter((item) => item && typeof item.criterion === "string" && typeof item.evidence === "string" && item.evidence.trim()).map((item) => item.criterion));
  return criteria.length ? criteria.every((criterion) => proven.has(criterion)) : proven.size > 0;
}

export function validateGraph(graph, knownAgents, limits = DEFAULT_LIMITS, config) {
  if (!graph || typeof graph.name !== "string" || !/^[A-Za-z0-9_-]+$/.test(graph.name) || !Array.isArray(graph.nodes) || graph.nodes.length === 0) throw new Error("graph requires a safe name and nodes");
  if (graph.nodes.length > limits.maxNodes) throw new Error(`graph exceeds maxNodes (${limits.maxNodes})`);
  if (graph.acceptanceCriteria !== undefined && (!Array.isArray(graph.acceptanceCriteria) || graph.acceptanceCriteria.some((item) => typeof item !== "string" || !item.trim()))) throw new Error("acceptanceCriteria must be an array of non-empty strings");
  const byId = new Map();
  const routed = graph.nodes.some((node) => Array.isArray(node?.routes));
  const decisionNodes = graph.nodes.some((node) => node?.kind === "review_loop" || ["reviewer", "security-reviewer", "verifier"].includes(node?.agent));
  if (decisionNodes && !routed) throw new Error("review and verifier nodes require explicit routed workflow branches");
  if (routed && (!graph.entry || typeof graph.entry !== "string")) throw new Error("routed graph requires an entry node");
  for (const node of graph.nodes) {
    if (!node?.id || typeof node.id !== "string" || !/^[A-Za-z0-9_-]+$/.test(node.id) || node.id === "_workflow" || !node.task) throw new Error("each node requires a safe id and task");
    if (byId.has(node.id)) throw new Error(`duplicate node id: ${node.id}`);
    const kind = node.kind ?? "task";
    if (!["task", "review_loop"].includes(kind)) throw new Error(`unknown node kind: ${kind}`);
    if (kind === "review_loop") {
      if (!knownAgents.has(node.editorAgent) || !knownAgents.has(node.reviewerAgent)) throw new Error(`review loop ${node.id} requires known editorAgent and reviewerAgent`);
      if (!Number.isInteger(node.maxPasses ?? 3) || (node.maxPasses ?? 3) < 1 || (node.maxPasses ?? 3) > 3) throw new Error(`review loop ${node.id} maxPasses must be between 1 and 3`);
    } else if (!knownAgents.has(node.agent)) throw new Error(`unknown agent: ${node.agent}`);
    if ((node.retries ?? 0) > limits.maxRetries) throw new Error(`node ${node.id} exceeds maxRetries`);
    if (node.retries !== undefined && (!Number.isInteger(node.retries) || node.retries < 0)) throw new Error("invalid retries");
    if (node.dependsOn !== undefined && (!Array.isArray(node.dependsOn) || node.dependsOn.some((id) => typeof id !== "string"))) throw new Error("dependsOn must be an array of node ids");
    if (node.routes !== undefined && !Array.isArray(node.routes)) throw new Error(`node ${node.id} routes must be an array`);
    if (config) {
      const tierNames = config.tiers;
      if (kind === "task" && !node.model) {
        const tier = node.tier ?? config.roles[node.agent];
        if (!tierNames[tier]) throw new Error(`node ${node.id} has no configured model tier`);
      }
      if (kind === "review_loop") {
        const editorTier = node.editorTier ?? config.roles[node.editorAgent];
        const reviewerTier = node.reviewerTier ?? config.roles[node.reviewerAgent];
        if (!tierNames[editorTier] || !tierNames[reviewerTier]) throw new Error(`review loop ${node.id} has an unknown model tier`);
      } else if (node.tier && !tierNames[node.tier]) throw new Error(`node ${node.id} uses unknown model tier ${node.tier}`);
    }
    byId.set(node.id, { ...node, kind, dependsOn: node.dependsOn ?? [], retries: node.retries ?? limits.maxRetries, ...(kind === "review_loop" ? { maxPasses: node.maxPasses ?? 3 } : {}) });
  }
  if (graph.entry && !byId.has(graph.entry)) throw new Error(`graph entry node does not exist: ${graph.entry}`);
  for (const node of byId.values()) {
    if (routed && node.kind !== "review_loop" && node.agent !== "verifier" && (!node.routes || node.routes.length === 0)) throw new Error(`routed workflow node ${node.id} requires at least one outgoing route`);
    if (routed && node.kind === "review_loop" && (!node.routes || node.routes.length === 0)) throw new Error(`review loop ${node.id} requires an outgoing route`);
    for (const dependency of node.dependsOn) if (!byId.has(dependency)) throw new Error(`node ${node.id} depends on missing node ${dependency}`);
    if (node.routes) {
      const routeIds = new Set();
      for (const route of node.routes) {
        if (!route || typeof route.id !== "string" || !/^[A-Za-z0-9_-]+$/.test(route.id) || routeIds.has(route.id)) throw new Error(`node ${node.id} has an invalid or duplicate route id`);
        routeIds.add(route.id);
        if (route.description !== undefined && typeof route.description !== "string") throw new Error(`route ${route.id} description must be a string`);
        if (typeof route.to !== "string" || (!byId.has(route.to) && !TERMINAL_ROUTES.has(route.to))) throw new Error(`route ${route.id} from ${node.id} has an unknown target`);
        if (route.to === "complete" && (node.kind === "review_loop" || node.agent !== "verifier")) throw new Error("only a verifier node may route to complete");
        if (route.when !== undefined) {
          if (!route.when || typeof route.when !== "object" || Array.isArray(route.when) || Object.keys(route.when).some((key) => !["status", "decision"].includes(key)) || Object.keys(route.when).length === 0) throw new Error(`route ${route.id} has invalid conditions`);
          if (route.when.status !== undefined && !STATUSES.has(route.when.status)) throw new Error(`route ${route.id} has invalid status condition`);
          if (route.when.decision !== undefined && !DECISIONS.has(route.when.decision)) throw new Error(`route ${route.id} has invalid decision condition`);
        }
      }
    }
  }
  const visiting = new Set(); const visited = new Set();
  const visit = (id, depth = 1) => {
    if (depth > limits.maxNodes) throw new Error("graph exceeds maximum dependency depth");
    if (visiting.has(id)) throw new Error("graph contains a cycle");
    if (visited.has(id)) return;
    visiting.add(id);
    for (const dependency of byId.get(id).dependsOn) visit(dependency, depth + 1);
    visiting.delete(id); visited.add(id);
  };
  for (const id of byId.keys()) visit(id);
  if (routed) {
    const routeVisiting = new Set(); const routeVisited = new Set();
    const visitRoute = (id) => {
      if (routeVisiting.has(id)) throw new Error("routed graph contains a cycle; use a bounded review_loop node");
      if (routeVisited.has(id)) return;
      routeVisiting.add(id);
      for (const route of byId.get(id).routes ?? []) if (byId.has(route.to)) visitRoute(route.to);
      routeVisiting.delete(id); routeVisited.add(id);
    };
    for (const id of byId.keys()) visitRoute(id);
  }
  const normalized = { name: graph.name, nodes: [...byId.values()], ...(graph.entry ? { entry: graph.entry } : {}), ...(graph.acceptanceCriteria ? { acceptanceCriteria: graph.acceptanceCriteria } : {}) };
  return { ...normalized, hash: stableHash(normalized), routed };
}

const snapshotStates = (states) => structuredClone(Object.fromEntries(states));

export async function scheduleGraph(graph, executeNode, options = {}) {
  if (graph.routed) return scheduleRoutedGraph(graph, executeNode, options);
  const limits = { ...DEFAULT_LIMITS, ...options.limits };
  const initial = options.initialState ?? {};
  const states = new Map(graph.nodes.map((node) => {
    const previous = initial[node.id];
    const state = previous ? structuredClone(previous) : { status: "pending", retries: 0 };
    if (state.status === "running") state.status = "pending";
    if (state.status === "failed" || state.status === "skipped") { state.status = "pending"; state.retries = 0; }
    return [node.id, state];
  }));
  let saving = Promise.resolve();
  const persist = () => {
    const snapshot = snapshotStates(states);
    saving = saving.then(() => options.onState?.(snapshot));
    return saving;
  };
  await persist();
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
    if (!ready.length || options.signal?.aborted) { for (const node of graph.nodes) if (states.get(node.id).status === "pending") states.set(node.id, { status: "skipped", reason: options.signal?.aborted ? "cancelled" : "failed dependency", retries: 0 }); await persist(); break; }
    await Promise.all(ready.map(async (node) => {
      let retries = states.get(node.id).retries ?? 0;
      while (true) {
        states.set(node.id, { ...states.get(node.id), status: "running", retries, workspace: node.workspace });
        await persist();
        let result;
        let failure;
        try {
          const predecessors = Object.fromEntries(node.dependsOn.map((id) => [id, structuredClone(states.get(id).result)]));
          result = await executeNode(node, predecessors, (progress) => {
            states.set(node.id, { ...states.get(node.id), progress: structuredClone(progress) });
            return persist();
          });
          if (result && typeof result === "object" && "status" in result && result.status !== "ok") throw new Error(`node returned ${result.status}`);
        } catch (error) { failure = error; }
        if (!failure) { states.set(node.id, { status: "ok", result, retries, workspace: node.workspace }); await persist(); break; }
        if (retries >= node.retries || options.signal?.aborted) { states.set(node.id, { ...states.get(node.id), status: "failed", error: String(failure), retries, workspace: node.workspace }); await persist(); break; }
        retries += 1;
      }
    }));
  }
  return Object.fromEntries(states);
}

function routeMatches(route, result) {
  if (!route.when) return false;
  return Object.entries(route.when).every(([key, value]) => result[key] === value);
}

export async function scheduleRoutedGraph(graph, executeNode, options = {}) {
  const initial = options.initialState ?? {};
  const states = Object.fromEntries(graph.nodes.map((node) => [node.id, initial[node.id] ? structuredClone(initial[node.id]) : { status: "pending", retries: 0 }]));
  const previousMeta = initial._workflow ?? {};
  const meta = { status: "running", entry: graph.entry, currentNode: previousMeta.currentNode ?? graph.entry, nextNode: previousMeta.nextNode ?? null, routeHistory: previousMeta.routeHistory ?? [] };
  const persist = async () => options.onState?.({ ...structuredClone(states), _workflow: structuredClone(meta) });
  const settled = (status, reason) => {
    meta.status = status;
    if (reason) meta.reason = reason;
    for (const node of graph.nodes) if (states[node.id].status === "pending" || states[node.id].status === "running") states[node.id] = { ...states[node.id], status: "skipped", reason: `workflow ${status}` };
    return persist().then(() => ({ ...structuredClone(states), _workflow: structuredClone(meta) }));
  };
  const maxSteps = graph.nodes.length;
  let current = meta.nextNode ?? meta.currentNode;
  for (let step = 0; current && step < maxSteps; step++) {
    if (options.signal?.aborted) return settled("cancelled");
    const node = graph.nodes.find((candidate) => candidate.id === current);
    if (!node) return settled("needs_user", `unknown next node: ${current}`);
    if (states[current].status === "ok") return settled("needs_user", `cannot resume completed node ${current} without its saved next route`);
    if (states[current].status === "failed" || states[current].status === "skipped") states[current] = { ...states[current], status: "pending", retries: 0 };
    meta.currentNode = current;
    meta.nextNode = null;
    states[current] = { ...states[current], status: "running", retries: states[current].retries ?? 0, workspace: node.workspace };
    await persist();
    let result;
    let failure;
    let retries = states[current].retries;
    while (true) {
      try {
        const predecessorIds = node.dependsOn.length ? node.dependsOn : meta.routeHistory.length ? [meta.routeHistory.at(-1).from] : [];
        const predecessors = Object.fromEntries(predecessorIds.filter((id) => states[id]?.result !== undefined).map((id) => [id, structuredClone(states[id].result)]));
        result = await executeNode(node, predecessors, (progress) => {
          states[current] = { ...states[current], progress: structuredClone(progress), retries };
          return persist();
        });
        if (!result || typeof result !== "object" || !STATUSES.has(result.status)) throw new Error("node returned an invalid workflow result");
        if (result.status !== "ok") throw new Error(`node returned ${result.status}: ${result.summary ?? ""}`);
        break;
      } catch (error) {
        failure = error;
        if (retries >= node.retries || options.signal?.aborted) break;
        retries += 1;
        states[current] = { ...states[current], status: "running", retries };
        await persist();
      }
    }
    if (failure) {
      states[current] = { ...states[current], status: "failed", retries, error: String(failure) };
      await persist();
      return settled(options.signal?.aborted ? "cancelled" : "failed", String(failure));
    }
    states[current] = { status: "ok", retries, result, workspace: node.workspace };
    await persist();
    if (result.decision === "complete") {
      if (node.kind === "review_loop" || node.agent !== "verifier") return settled("needs_user", "only a verifier may complete a goal");
      if (!hasAcceptanceEvidence(result, graph.acceptanceCriteria ?? [])) return settled("needs_user", "verifier did not provide evidence for every acceptance criterion");
      return settled("complete");
    }
    if (result.decision === "needs_user") return settled("needs_user", result.summary);
    if (result.decision === "replan" && !(node.routes?.length)) return settled("replan", result.summary);
    const routes = node.routes ?? [];
    if (!routes.length) return settled("finished", result.summary);
    const matches = routes.filter((route) => routeMatches(route, result));
    const defaults = routes.filter((route) => !route.when);
    const eligible = matches.length ? matches : defaults.length ? defaults : routes.length > 1 ? routes : [];
    let selected;
    let selectionReason;
    if (eligible.length === 1) {
      selected = eligible[0];
      selectionReason = matches.length === 1 || (matches.length === 0 && defaults.length === 1) ? "deterministic condition" : "only eligible route";
    } else {
      const choice = await options.chooseRoute?.(eligible, { graph: graph.name, node: node.id, result, routeHistory: meta.routeHistory }, options.signal);
      selected = choice?.route;
      selectionReason = choice?.reason;
    }
    if (!selected) return settled("needs_user", selectionReason ?? (eligible.length ? "route selection failed" : "no declared route matches this outcome"));
    meta.routeHistory.push({ from: node.id, routeId: selected.id, to: selected.to, decision: result.decision, reason: selectionReason });
    meta.nextNode = graph.nodes.some((candidate) => candidate.id === selected.to) ? selected.to : null;
    await persist();
    if (selected.to === "needs_user") return settled("needs_user", selectionReason ?? result.summary);
    if (selected.to === "complete") {
      if (node.kind === "review_loop" || node.agent !== "verifier" || result.decision !== "complete") return settled("needs_user", "completion route requires verifier evidence");
      if (!hasAcceptanceEvidence(result, graph.acceptanceCriteria ?? [])) return settled("needs_user", "verifier did not provide evidence for every acceptance criterion");
      return settled("complete");
    }
    if (selected.to === "replan") return settled("replan", result.summary);
    current = selected.to;
  }
  return settled(current ? "needs_user" : "finished", current ? "routed graph exceeded its node limit" : undefined);
}
