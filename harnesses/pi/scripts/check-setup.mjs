import { readFileSync, realpathSync, readdirSync } from "node:fs";
import { homedir } from "node:os";
import { join, dirname } from "node:path";
import YAML from "yaml";
import { Ajv2020 } from "ajv/dist/2020.js";
import { routeTemplate } from "../lib/workflows.mjs";
import { validateGraph } from "../lib/graph.mjs";
import { DefaultResourceLoader, SettingsManager } from "@earendil-works/pi-coding-agent";
import { validatePackages } from "../lib/packages.mjs";

// Use the pinned SDK's command catalogue, also used by its interactive mode.
const { BUILTIN_SLASH_COMMANDS } = await import(new URL("./core/slash-commands.js", import.meta.resolve("@earendil-works/pi-coding-agent")));
const readJson = (path) => JSON.parse(readFileSync(path, "utf8"));
const agentDir = process.env.PI_CODING_AGENT_DIR ?? join(homedir(), ".pi", "agent");
const settings = readJson(join(agentDir, "settings.json"));
const lock = readJson(new URL("../packages.lock.json", import.meta.url));
const packages = validatePackages(lock, settings);
const sharedRoot = dirname(realpathSync(join(agentDir, "agents")));
new Ajv2020({ strict: true }).compile(readJson(join(sharedRoot, "schemas/task-contract.schema.json")));
const agents = new Set(["explorer", "planner", "architect", "implementer", "debugger", "reviewer", "security-reviewer", "verifier"]);
const workflows = readdirSync(join(sharedRoot, "workflows")).filter((file) => file.endsWith(".yaml"));
for (const file of workflows) {
  validateGraph(routeTemplate(YAML.parse(readFileSync(join(sharedRoot, "workflows", file), "utf8"))), agents, undefined, readJson(join(agentDir, "harness.json")));
}

// Fail before resource loading if a package is absent or stale, rather than
// letting the loader install it as a side effect of this check.
for (const spec of packages) {
  const match = /^npm:(.+)@([^@]+)$/.exec(spec);
  const manifest = readJson(join(agentDir, "npm", "node_modules", match[1], "package.json"));
  if (manifest.version !== match[2]) throw new Error(`${spec}: installed version is ${manifest.version}; synchronize Pi packages first`);
}

const loader = new DefaultResourceLoader({
  cwd: process.env.INIT_CWD ?? process.cwd(), agentDir,
  settingsManager: SettingsManager.inMemory(settings)
});
await loader.reload();
const loaded = loader.getExtensions();
const diagnostics = [...loaded.errors, ...(loaded.warnings ?? [])];
const builtinNames = new Set(BUILTIN_SLASH_COMMANDS.map((command) => command.name));
for (const extension of loaded.extensions) {
  for (const name of extension.commands.keys()) {
    if (builtinNames.has(name)) diagnostics.push({ path: extension.path, error: `/${name} conflicts with a built-in interactive command` });
  }
}
for (const resources of [loader.getSkills(), loader.getPrompts(), loader.getThemes()]) diagnostics.push(...resources.diagnostics);
if (diagnostics.length) {
  console.error(JSON.stringify(diagnostics, null, 2));
  process.exitCode = 1;
} else {
  console.log(`Pi setup OK: ${packages.length} pinned packages, ${loaded.extensions.length} loaded extensions, ${workflows.length} validated workflows, shared contract schema valid, no resource warnings or command conflicts.`);
}
