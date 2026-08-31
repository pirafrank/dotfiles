import { readFile } from "node:fs/promises";
import { join } from "node:path";
import { homedir } from "node:os";
import { randomUUID } from "node:crypto";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import YAML from "yaml";
import { scheduleGraph, validateGraph } from "../../lib/graph.mjs";
import { saveRun } from "../../lib/runs.mjs";
import { runDelegatedTask } from "./delegate.ts";

const graphs = new Map<string, any>();
const agents = new Set(["explorer", "planner", "architect", "implementer", "debugger", "reviewer", "security-reviewer", "verifier"]);
const workflowPath = (name: string) => join(homedir(), ".agents", "workflows", `${name}.yaml`);

async function resolveGraph(value: string) {
  const source = value.trim().startsWith("{") ? JSON.parse(value) : YAML.parse(await readFile(workflowPath(value), "utf8"));
  return validateGraph(source, agents);
}

export function registerGraph(pi: ExtensionAPI) {
  pi.registerTool({ name: "graph_create", label: "Create graph", description: "Validate and store a static workflow template or graph JSON.", parameters: Type.Object({ graph: Type.String() }), async execute(_id: string, params: any) {
    const graph = await resolveGraph(params.graph); graphs.set(graph.name, graph);
    return { content: [{ type: "text", text: `${graph.name}: ${graph.nodes.length} validated nodes` }], details: { graph } };
  }});
  pi.registerTool({ name: "graph_run", label: "Run graph", description: "Run a previously validated static graph.", parameters: Type.Object({ name: Type.String() }), async execute(_id: string, params: any, signal: AbortSignal) {
    const graph = graphs.get(params.name); if (!graph) throw new Error(`graph is not validated: ${params.name}`);
    const runId = randomUUID();
    const state = await scheduleGraph(graph, async (node: any) => {
      const result = await runDelegatedTask({ agent: node.agent, task: node.task, model: node.model, timeoutMs: node.timeoutMs }, signal);
      return { ...result.result, agent: result.agent, transcript: result.raw.slice(-16384) };
    });
    const directory = await saveRun(graph, runId, { runId, graphHash: graph.hash, state, completedAt: new Date().toISOString() });
    return { content: [{ type: "text", text: `${graph.name} completed; run state: ${directory}` }], details: { runId, state, directory } };
  }});
  pi.registerTool({ name: "graph_status", label: "Graph status", description: "Show the in-session validated graph summary.", parameters: Type.Object({ name: Type.String() }), async execute(_id: string, params: any) {
    const graph = graphs.get(params.name); if (!graph) throw new Error(`unknown graph: ${params.name}`);
    return { content: [{ type: "text", text: `${graph.name}: ${graph.nodes.map((node: any) => node.id).join(" -> ")}` }], details: { graph } };
  }});
}
