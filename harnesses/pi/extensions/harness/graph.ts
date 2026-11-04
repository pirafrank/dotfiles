import { readFile, realpath } from "node:fs/promises";
import { join, dirname } from "node:path";
import { homedir } from "node:os";
import { randomUUID } from "node:crypto";
import type { ExtensionAPI, ExtensionToolContext } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import YAML from "yaml";
import { Ajv2020 } from "ajv/dist/2020.js";
import { scheduleGraph, validateGraph, stableHash } from "../../lib/graph.mjs";
import { saveRun, loadRunById, withRunLock, withWorkspaceLock } from "../../lib/runs.mjs";
import { chooseGraphRoute, chooseTierModel, getTierCandidates, validateModelConfig } from "../../lib/model-selection.mjs";
import { routeTemplate } from "../../lib/workflows.mjs";
import { captureSource } from "../../lib/source.mjs";
import { runGovernedGraph, validateContract } from "../../lib/governance.mjs";
import { runDelegatedTask } from "./delegate.ts";

const graphs = new Map<string, any>();
const agents = new Set(["explorer", "planner", "architect", "implementer", "debugger", "reviewer", "security-reviewer", "verifier"]);
const workflowSchema = JSON.parse(await readFile(new URL("../../schemas/workflow-result.schema.json", import.meta.url), "utf8"));
const validateWorkflowResult = new Ajv2020({ strict: true }).compile(workflowSchema);
const graphPlanSchema = JSON.parse(await readFile(new URL("../../schemas/graph-plan-result.schema.json", import.meta.url), "utf8"));
const validateGraphPlan = new Ajv2020({ strict: true }).compile(graphPlanSchema);
const configUrl = new URL("../../harness.json", import.meta.url);
const rolesDirectory = () => join(homedir(), ".pi", "agent", "agents");
const workflowPath = async (name: string) => join(dirname(await realpath(rolesDirectory())), "workflows", `${name}.yaml`);

async function loadConfig(ctx: ExtensionToolContext) {
  const config = JSON.parse(await readFile(configUrl, "utf8"));
  return validateModelConfig(config, ctx.modelRegistry);
}

async function resolveGraph(value: string, config: any, acceptanceCriteria?: string[]) {
  if (!value.trim().startsWith("{") && !/^[A-Za-z0-9_-]+$/.test(value)) throw new Error("invalid workflow name");
  let source = value.trim().startsWith("{") ? JSON.parse(value) : YAML.parse(await readFile(await workflowPath(value), "utf8"));
  if (acceptanceCriteria) source = { ...source, acceptanceCriteria };
  return validateGraph(value.trim().startsWith("{") ? source : routeTemplate(source), agents, undefined, config);
}

function availableModel(ctx: ExtensionToolContext, modelId: string) {
  return ctx.modelRegistry.getAvailable().find((model) => `${model.provider}/${model.id}` === modelId);
}

function isProviderFailure(error: unknown) {
  const message = String(error);
  if (message.startsWith("Delegated task ")) return false;
  return /provider|429|rate.?limit|quota|unauthori[sz]ed|authentication|credential|network|econn|eai_again|socket|fetch failed|timed? ?out|service unavailable|\b50[234]\b/i.test(message);
}

async function runWithTier(params: any, tierName: string, config: any, ctx: ExtensionToolContext, signal: AbortSignal | undefined, schema = workflowSchema, validate = validateWorkflowResult) {
  const selection = await chooseTierModel(config, ctx.modelRegistry, tierName, { task: params.task, agent: params.agent, context: params.context }, signal);
  const candidates = getTierCandidates(config, ctx.modelRegistry, tierName);
  const order = [selection.modelId, ...candidates.map(({ id }: { id: string }) => id).filter((id: string) => id !== selection.modelId)];
  const failures: string[] = [];
  for (const modelId of order) {
    const model = availableModel(ctx, modelId);
    if (!model) continue;
    try {
      const result = await runDelegatedTask({ ...params, model: modelId, schema }, signal);
      if (!validate(result.result)) throw new Error("invalid structured workflow result");
      if (["reviewer", "security-reviewer", "verifier"].includes(params.agent) && !result.result.decision) throw new Error(`${params.agent} must return a workflow decision`);
      return { ...result.result, selectedModel: modelId, modelTier: tierName, modelClass: config.tiers[tierName].class, modelSelection: modelId === selection.modelId ? selection.reason : `provider fallback after ${failures.length} failed candidate(s)` , modelFailures: failures };
    } catch (error) {
      if (!isProviderFailure(error)) throw error;
      failures.push(`${modelId}: ${String(error).slice(0, 300)}`);
      if (signal?.aborted) throw error;
    }
  }
  throw new Error(`all candidates in tier ${tierName} failed: ${failures.join("; ")}`);
}

async function executeReviewLoop(node: any, predecessors: any, reportProgress: (progress: unknown) => Promise<unknown>, config: any, ctx: ExtensionToolContext, signal: AbortSignal | undefined) {
  let priorFindings: string[] = [];
  let latestReview: any;
  for (let pass = 1; pass <= Math.min(node.maxPasses ?? config.reviewPasses, config.reviewPasses, 3); pass++) {
    const editContext = JSON.stringify({ predecessors, pass, priorFindings });
    const edit = await runWithTier({ agent: node.editorAgent, task: node.task, context: editContext, timeoutMs: node.timeoutMs }, node.editorTier ?? config.roles[node.editorAgent], config, ctx, signal);
    await reportProgress({ pass, stage: "edit", model: edit.selectedModel, summary: edit.summary });
    const review = await runWithTier({
      agent: node.reviewerAgent,
      task: `Review the editor result against the goal and acceptance criteria. Return decision=accept only if it is ready; return decision=revise with concrete findings otherwise.\n\nTask: ${node.task}`,
      context: JSON.stringify({ predecessors, edit, pass }),
      timeoutMs: node.timeoutMs
    }, node.reviewerTier ?? config.roles[node.reviewerAgent], config, ctx, signal);
    latestReview = review;
    await reportProgress({ pass, stage: "review", model: review.selectedModel, decision: review.decision, findings: review.findings ?? [] });
    if (review.decision === "accept") return { status: "ok", decision: "accept", summary: review.summary, evidence: review.evidence ?? [], findings: review.findings ?? [], passes: pass, selectedModels: [edit.selectedModel, review.selectedModel] };
    if (review.decision === "needs_user" || review.decision === "replan") return { ...review, passes: pass, selectedModels: [edit.selectedModel, review.selectedModel] };
    if (review.decision !== "revise") throw new Error(`reviewer returned unsupported decision: ${review.decision}`);
    priorFindings = review.findings ?? [review.summary];
  }
  return { status: "ok", decision: "needs_user", summary: `Review did not accept the work after ${Math.min(node.maxPasses ?? config.reviewPasses, config.reviewPasses, 3)} passes.`, findings: latestReview?.findings ?? priorFindings, evidence: latestReview?.evidence ?? [], passes: Math.min(node.maxPasses ?? config.reviewPasses, config.reviewPasses, 3) };
}

async function executeNode(node: any, predecessors: any, reportProgress: (progress: unknown) => Promise<unknown>, config: any, ctx: ExtensionToolContext, signal: AbortSignal | undefined) {
  if (node.kind === "review_loop") return executeReviewLoop(node, predecessors, reportProgress, config, ctx, signal);
  const tier = node.tier ?? config.roles[node.agent];
  return runWithTier({ agent: node.agent, task: node.task, context: JSON.stringify(predecessors), timeoutMs: node.timeoutMs }, tier, config, ctx, signal);
}

function preflightGraph(graph: any, config: any, ctx: ExtensionToolContext, initialState?: any) {
  for (const node of graph.nodes) {
    if (initialState?.[node.id]?.status === "ok") continue;
    if (node.kind === "review_loop") {
      getTierCandidates(config, ctx.modelRegistry, node.editorTier ?? config.roles[node.editorAgent]);
      getTierCandidates(config, ctx.modelRegistry, node.reviewerTier ?? config.roles[node.reviewerAgent]);
    } else if (node.model) {
      if (!availableModel(ctx, node.model)) throw new Error(`graph node ${node.id} model is not currently available: ${node.model}`);
    } else {
      getTierCandidates(config, ctx.modelRegistry, node.tier ?? config.roles[node.agent]);
    }
  }
}

async function runGraph(graph: any, runId: string, ctx: ExtensionToolContext, config: any, signal: AbortSignal | undefined, contract: any, previous?: any) {
  const source = await captureSource(ctx.cwd);
  const contractHash = await validateContract(contract, graph, source, rolesDirectory());
  preflightGraph(graph, config, ctx, previous?.state);
  const configHash = stableHash(config);
  const result = await withWorkspaceLock(source.root, () => withRunLock(graph.name, runId, () => runGovernedGraph({
    graph, runId, contract, contractHash, configHash, cwd: ctx.cwd, signal, previous,
    persist: (record: any) => saveRun(graph, runId, record),
    executeNode: (node: any, predecessors: any, reportProgress: any) => executeNode(node, predecessors, reportProgress, config, ctx, signal),
    chooseRoute: (routes: any[], context: any, routeSignal?: AbortSignal) => chooseGraphRoute(config, ctx.modelRegistry, routes, context, routeSignal),
    approve: async (gate: string, payload: any) => {
      if (!ctx.hasUI) return { approved: false, actor: "noninteractive" };
      const approved = await ctx.ui.confirm(`Human approval: ${gate}`, JSON.stringify(payload, null, 2));
      return { approved, actor: process.env.USER ?? "local operator" };
    }
  })));
  return { ...result, directory: (await loadRunById(runId)).directory };
}

export function registerGraph(pi: ExtensionAPI) {
  pi.on("before_agent_start", (event) => {
    event.systemPromptOptions.sections["goal-graph-workflow"] = [
      "For an active /goal, use graph_plan to have the configured planner tier produce explicit acceptance criteria and a validated workflow before editing.",
      "Run that graph with graph_run. Use graph_status and graph_resume for persisted runs. Follow structured outcomes and do not bypass route or permission decisions.",
      "Only call goal_complete after graph_run or graph_resume reports status=complete, including durable human completion approval. A verifier decision alone is insufficient. If a graph returns needs_user, failed, or cancelled, call goal_wait with the goal ID and reason so automatic continuation stops. If it returns replan or finished without verification, create and run a new graph. Never claim completion without verifier evidence."
    ].join(" ");
  });
  pi.registerTool({ name: "graph_plan", label: "Plan goal graph", description: "Use the configured planner model tier to turn a goal into acceptance criteria and a validated routed workflow graph; stores the graph for graph_run.", parameters: Type.Object({ goal: Type.String(), context: Type.Optional(Type.String()) }), async execute(_id: string, params: any, signal: AbortSignal | undefined, _update: any, ctx: ExtensionToolContext) {
    const config = await loadConfig(ctx);
    const planningTask = `Create a concise, executable routed workflow graph for this goal. Define measurable acceptance criteria. Use known agents only: ${[...agents].join(", ")}. Set graph.entry and give every node an explicit routes array; graph execution follows one selected path. Assign each task node a tier from ${Object.keys(config.tiers).join(", ")}; use kind=review_loop for bounded edit/review work, with editorAgent, reviewerAgent, editorTier, reviewerTier, maxPasses no greater than ${config.reviewPasses}, and an accept route to verification. Use route conditions with when.decision or when.status; use a default route only for a genuine unconditional continuation. Reviewer decisions are accept, revise, replan, or needs_user; only verifier nodes may return complete. The verifier must return decision=complete only when every acceptance criterion has a corresponding evidence object {criterion, evidence} with exact criterion text and concrete inspected/test evidence. Use only existing nodes as route targets plus needs_user, replan, or complete. Return the required JSON schema exactly.\n\nGoal: ${params.goal}${params.context ? `\nAdditional context: ${params.context}` : ""}`;
    const planned = await runWithTier({ agent: "planner", task: planningTask, context: params.context, timeoutMs: 300000 }, config.roles.planner, config, ctx, signal, graphPlanSchema, validateGraphPlan);
    if (!Array.isArray(planned.acceptanceCriteria) || planned.acceptanceCriteria.length === 0) throw new Error("planner returned no acceptance criteria");
    if (planned.graph.nodes.some((node: any) => node.model || (node.kind === "review_loop" ? (!node.editorTier || !node.reviewerTier) : !node.tier))) throw new Error("planner must assign named model tiers to every graph step; raw model IDs are reserved for manually authored legacy graphs");
    const graph = validateGraph({ ...planned.graph, acceptanceCriteria: planned.acceptanceCriteria }, agents, undefined, config);
    graphs.set(graph.name, graph);
    return { content: [{ type: "text", text: `Planned ${graph.name}: ${graph.nodes.length} nodes; acceptance criteria: ${planned.acceptanceCriteria.join("; ")}` }], details: { graph, summary: planned.summary, selectedModel: planned.selectedModel, modelTier: planned.modelTier } };
  }});
  pi.registerTool({ name: "graph_create", label: "Create graph", description: "Validate and store a static dependency graph or bounded routed workflow.", parameters: Type.Object({ graph: Type.String(), acceptanceCriteria: Type.Optional(Type.Array(Type.String({ minLength: 1 }))) }), async execute(_id: string, params: any, _signal: AbortSignal | undefined, _update: any, ctx: ExtensionToolContext) {
    const config = await loadConfig(ctx);
    const graph = await resolveGraph(params.graph, config, params.acceptanceCriteria); graphs.set(graph.name, graph);
    return { content: [{ type: "text", text: `${graph.name}: ${graph.nodes.length} validated nodes${graph.routed ? `, entry ${graph.entry}` : ""}` }], details: { graph } };
  }});
  pi.registerTool({ name: "graph_run", label: "Run graph", description: "Run a validated graph with configured model tiers, structured outcomes, and bounded review loops.", parameters: Type.Object({ name: Type.String(), contract: Type.String({ description: "JSON task contract: goal, repository absolute root, baseSha, acceptanceCriteria, approvalGates={scope:true,completion:true}" }) }), async execute(_id: string, params: any, signal: AbortSignal | undefined, _update: any, ctx: ExtensionToolContext) {
    const graph = graphs.get(params.name); if (!graph) throw new Error(`graph is not validated: ${params.name}`);
    const config = await loadConfig(ctx);
    const validated = validateGraph(graph, agents, undefined, config);
    const runId = randomUUID();
    const { state, directory, status } = await runGraph(validated, runId, ctx, config, signal, JSON.parse(params.contract));
    return { isError: ["failed", "cancelled"].includes(status), content: [{ type: "text", text: `${validated.name} ${status}; run id: ${runId}; state: ${directory}` }], details: { runId, status, state, directory } };
  }});
  pi.registerTool({ name: "graph_resume", label: "Resume graph", description: "Resume a persisted graph run by its run ID, preserving completed nodes and restarting interrupted work.", parameters: Type.Object({ runId: Type.String() }), async execute(_id: string, params: any, signal: AbortSignal | undefined, _update: any, ctx: ExtensionToolContext) {
    const bundle = await loadRunById(params.runId);
    const config = await loadConfig(ctx);
    const graph = validateGraph(bundle.graph, agents, undefined, config);
    if (graph.hash !== bundle.run.graphHash) throw new Error("saved graph hash does not match run state");
    if (bundle.run.configHash && bundle.run.configHash !== stableHash(config)) throw new Error("harness model-tier configuration changed; create a new graph run instead of resuming with different routing");
    if (!bundle.run.contract) throw new Error("Legacy run has no approved contract; create a new run");
    const { state, directory, status } = await runGraph(graph, params.runId, ctx, config, signal, bundle.run.contract, bundle.run);
    return { isError: ["failed", "cancelled"].includes(status), content: [{ type: "text", text: `${graph.name} ${status}; run id: ${params.runId}; state: ${directory}` }], details: { runId: params.runId, status, state, directory } };
  }});
  pi.registerTool({ name: "graph_status", label: "Graph status", description: "Inspect a validated graph template or persisted run.", parameters: Type.Object({ name: Type.Optional(Type.String()), runId: Type.Optional(Type.String()) }), async execute(_id: string, params: any) {
    if (params.runId) {
      const bundle = await loadRunById(params.runId);
      return { content: [{ type: "text", text: `${bundle.graph.name} ${bundle.run.phase === "complete" ? "complete" : bundle.run.phase === "review" || bundle.run.phase === "scope" ? "needs_user" : bundle.run.state?._workflow?.status ?? "run state available"}; run id: ${params.runId}` }], details: { graph: bundle.graph, state: bundle.run.state, phase: bundle.run.phase, approvals: bundle.run.approvals, source: bundle.run.source, contract: bundle.run.contract } };
    }
    if (typeof params.name !== "string") throw new Error("provide a graph name or runId");
    const graph = graphs.get(params.name); if (!graph) throw new Error(`unknown graph: ${params.name}`);
    return { content: [{ type: "text", text: `${graph.name}: ${graph.nodes.map((node: any) => node.id).join(" -> ")}` }], details: { graph, state: undefined, phase: undefined, approvals: undefined, source: undefined, contract: undefined } };
  }});
}
