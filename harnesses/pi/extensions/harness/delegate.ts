import { readdir, readFile, realpath } from "node:fs/promises";
import { join, dirname } from "node:path";
import { homedir } from "node:os";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

import YAML from "yaml";
import { Ajv2020 } from "ajv/dist/2020.js";
import { delegatedArgs, runPi } from "../../lib/delegate.mjs";

type Agent = { name: string; prompt: string; model?: string; tools?: string[] };
const agentsDirectory = () => join(homedir(), ".pi", "agent", "agents");

async function findAgent(name: string): Promise<Agent> {
  for (const entry of await readdir(agentsDirectory())) {
    if (!entry.endsWith(".md")) continue;
    const raw = await readFile(join(agentsDirectory(), entry), "utf8");
    const match = raw.match(/^---\n([\s\S]*?)\n---\n?([\s\S]*)$/);
    if (!match) continue;
    const frontmatter = YAML.parse(match[1]);
    const tools = typeof frontmatter.tools === "string" ? frontmatter.tools.split(",").map((tool: string) => tool.trim()) : frontmatter.tools;
    if (tools !== undefined && (!Array.isArray(tools) || tools.some((tool: unknown) => typeof tool !== "string"))) throw new Error("invalid tools for role: " + name);
    if (frontmatter.name === name) return { name, prompt: match[2], model: frontmatter.model, tools };
  }
  throw new Error(`unknown agent: ${name}`);
}

export function registerDelegate(pi: ExtensionAPI) {
  pi.registerTool({
    name: "delegate", label: "Delegate", description: "Run one focused specialist in an isolated Pi process.",
    parameters: Type.Object({ agent: Type.String(), task: Type.String(), context: Type.Optional(Type.String()), model: Type.Optional(Type.String()), timeoutMs: Type.Optional(Type.Integer({ minimum: 1000, maximum: 900000 })) }),
    async execute(_id: string, params: any, signal: AbortSignal | undefined) {
      const result = await runDelegatedTask(params, signal);
      const text = JSON.stringify(result.result);
      return { content: [{ type: "text", text }], details: { agent: result.agent, result: result.result, transcript: result.raw } };
    }
  });
}

export async function runDelegatedTask(params: { agent: string; task: string; context?: string; model?: string; timeoutMs?: number; schema?: Record<string, unknown> }, signal: AbortSignal | undefined) {
  const agent = await findAgent(params.agent);
  let schema = params.schema;
  if (!schema) {
    const rolesRoot = await realpath(agentsDirectory());
    schema = JSON.parse(await readFile(join(dirname(rolesRoot), "schemas", "node-result.schema.json"), "utf8"));
  }
  const validate = new Ajv2020({ strict: true }).compile(schema);
  const args = delegatedArgs(agent, { ...params, schema });
  const output = await runPi(args, params.timeoutMs ?? 300000, signal, validate);
  return { agent: agent.name, ...output };
}
