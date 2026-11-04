import { mkdir, readFile, readdir, writeFile, rename } from "node:fs/promises";
import { join } from "node:path";
import { homedir } from "node:os";
import { rm } from "node:fs/promises";
import { createHash } from "node:crypto";

const runRoot = () => join(homedir(), ".local", "state", "pi-harness", "runs");
export function runDirectory(graphName, runId) {
  if (!/^[A-Za-z0-9_-]+$/.test(graphName) || !/^[a-f0-9-]{36}$/i.test(runId)) throw new Error("invalid graph name or run ID");
  return join(runRoot(), graphName, runId);
}
export async function saveRun(graph, runId, state) {
  const directory = runDirectory(graph.name, runId);
  await mkdir(directory, { recursive: true });
  await writeFile(join(directory, "graph.json"), JSON.stringify(graph, null, 2));
  await writeFile(join(directory, "state.json.tmp"), JSON.stringify(state, null, 2));
  await rename(join(directory, "state.json.tmp"), join(directory, "state.json"));
  return directory;
}
export async function withRunLock(graphName, runId, operation) {
  const directory = runDirectory(graphName, runId);
  await mkdir(directory, { recursive: true });
  const lock = join(directory, "active.lock");
  try { await mkdir(lock); }
  catch (error) {
    if (error.code === "EEXIST") throw new Error(`Run is locked: ${lock}. After a crash, verify no runner is active before manually removing the lock directory.`);
    throw error;
  }
  try { return await operation(); }
  finally { await rm(lock, { recursive: true }); }
}
export async function withWorkspaceLock(root, operation) {
  const directory = join(runRoot(), "..", "workspace-locks");
  await mkdir(directory, { recursive: true });
  const lock = join(directory, createHash("sha256").update(root).digest("hex"));
  try { await mkdir(lock); }
  catch (error) {
    if (error.code === "EEXIST") throw new Error(`Checkout is locked: ${lock}. Verify no runner is active before removing a stale lock.`);
    throw error;
  }
  try { return await operation(); }
  finally { await rm(lock, { recursive: true }); }
}
export async function loadRun(graphName, runId) { return JSON.parse(await readFile(join(runDirectory(graphName, runId), "state.json"), "utf8")); }
export async function loadRunById(runId) {
  if (!/^[a-f0-9-]{36}$/i.test(runId)) throw new Error("invalid run ID");
  let graphNames;
  try { graphNames = await readdir(runRoot()); }
  catch (error) { if (error.code === "ENOENT") throw new Error(`graph run not found: ${runId}`); throw error; }
  for (const graphName of graphNames) {
    if (!/^[A-Za-z0-9_-]+$/.test(graphName)) continue;
    const directory = runDirectory(graphName, runId);
    try {
      const [graph, run] = await Promise.all([
        readFile(join(directory, "graph.json"), "utf8").then(JSON.parse),
        readFile(join(directory, "state.json"), "utf8").then(JSON.parse)
      ]);
      return { graph, run, directory };
    } catch (error) {
      if (error.code !== "ENOENT") throw error;
    }
  }
  throw new Error(`graph run not found: ${runId}`);
}
