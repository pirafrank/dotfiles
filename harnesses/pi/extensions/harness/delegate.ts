import { spawn } from "node:child_process";
import { readdir, readFile } from "node:fs/promises";
import { join } from "node:path";
import { homedir } from "node:os";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

type Agent = { name: string; prompt: string; model?: string };
const agentsDirectory = () => join(homedir(), ".pi", "agent", "agents");

async function findAgent(name: string): Promise<Agent> {
  for (const entry of await readdir(agentsDirectory())) {
    if (!entry.endsWith(".md")) continue;
    const raw = await readFile(join(agentsDirectory(), entry), "utf8");
    const match = raw.match(/^---\n([\s\S]*?)\n---\n?([\s\S]*)$/);
    if (!match) continue;
    const frontmatter = Object.fromEntries(match[1].split("\n").map((line) => line.split(/:\s*/, 2)).filter(([key]) => key));
    if (frontmatter.name === name) return { name, prompt: match[2], model: frontmatter.model };
  }
  throw new Error(`unknown agent: ${name}`);
}

function runPi(args: string[], timeoutMs: number, signal: AbortSignal): Promise<string> {
  return new Promise((resolve, reject) => {
    const child = spawn(process.env.PI_BIN ?? "pi", args, { stdio: ["ignore", "pipe", "pipe"] });
    let stdout = ""; let stderr = "";
    const timer = setTimeout(() => child.kill("SIGTERM"), timeoutMs);
    signal.addEventListener("abort", () => child.kill("SIGTERM"), { once: true });
    child.stdout.on("data", (chunk) => { stdout += chunk; }); child.stderr.on("data", (chunk) => { stderr += chunk; });
    child.on("error", reject);
    child.on("close", (code) => { clearTimeout(timer); code === 0 ? resolve(stdout) : reject(new Error(stderr || `pi exited ${code}`)); });
  });
}

function parseResult(raw: string) {
  for (const line of raw.trim().split("\n").reverse()) {
    try {
      const value = JSON.parse(line);
      if (value && typeof value.status === "string" && typeof value.summary === "string") return value;
    } catch { /* JSON event stream lines may not be final agent output. */ }
  }
  return { status: "ok", summary: raw.trim().slice(-4096), files: [], findings: [], risks: [], uncertainties: [] };
}

export function registerDelegate(pi: ExtensionAPI) {
  pi.registerTool({
    name: "delegate", label: "Delegate", description: "Run one focused specialist in an isolated Pi process.",
    parameters: Type.Object({ agent: Type.String(), task: Type.String(), context: Type.Optional(Type.String()), model: Type.Optional(Type.String()), timeoutMs: Type.Optional(Type.Integer({ minimum: 1000, maximum: 900000 })) }),
    async execute(_id: string, params: any, signal: AbortSignal) {
      const result = await runDelegatedTask(params, signal);
      const text = result.raw.slice(-16384);
      return { content: [{ type: "text", text }], details: { agent: result.agent, transcript: result.raw } };
    }
  });
}

export async function runDelegatedTask(params: { agent: string; task: string; context?: string; model?: string; timeoutMs?: number }, signal: AbortSignal) {
  const agent = await findAgent(params.agent);
  const prompt = `${agent.prompt}\n\nReturn concise JSON with status, summary, files, findings, risks, and uncertainties.\n\nTask: ${params.task}${params.context ? `\nContext:\n${params.context}` : ""}`;
  const args = ["--mode", "json", "--system-prompt", prompt, params.task];
  const selectedModel = params.model ?? agent.model;
  if (selectedModel) args.push("--model", selectedModel);
  const raw = await runPi(args, params.timeoutMs ?? 300000, signal);
  return { agent: agent.name, raw, result: parseResult(raw) };
}
