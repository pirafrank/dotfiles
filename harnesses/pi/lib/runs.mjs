import { mkdir, readFile, writeFile } from "node:fs/promises";
import { join } from "node:path";
import { homedir } from "node:os";

export function runDirectory(graphName, runId) { return join(homedir(), ".local", "state", "pi-harness", "runs", graphName, runId); }
export async function saveRun(graph, runId, state) {
  const directory = runDirectory(graph.name, runId);
  await mkdir(directory, { recursive: true });
  await writeFile(join(directory, "graph.json"), JSON.stringify(graph, null, 2));
  await writeFile(join(directory, "state.json"), JSON.stringify(state, null, 2));
  return directory;
}
export async function loadRun(graphName, runId) { return JSON.parse(await readFile(join(runDirectory(graphName, runId), "state.json"), "utf8")); }
