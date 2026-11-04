import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { lstat, readFile, readlink, realpath } from "node:fs/promises";
import { join, dirname, relative, isAbsolute } from "node:path";
import { stableHash } from "./graph.mjs";

const exec = promisify(execFile);
const git = async (cwd, args) => (await exec("git", ["--no-optional-locks", ...args], { cwd, maxBuffer: 32 * 1024 * 1024 })).stdout;

export async function captureSource(cwd) {
  const root = (await git(cwd, ["rev-parse", "--show-toplevel"])).trim();
  const head = (await git(root, ["rev-parse", "HEAD"])).trim();
  const index = await git(root, ["ls-files", "--stage", "-z"]);
  const paths = [...new Set((await git(root, ["ls-files", "--cached", "--others", "--exclude-standard", "-z"])).split("\0").filter(Boolean))].sort();
  const files = {};
  for (const path of paths) {
    try {
      const parent = relative(root, await realpath(dirname(join(root, path))));
      if (isAbsolute(parent) || parent === ".." || parent.startsWith("../")) throw new Error(`source parent escapes checkout: ${path}`);
      const stat = await lstat(join(root, path));
      if (stat.isDirectory()) throw new Error(`submodules are not supported by source checkpoints: ${path}`);
      if (!stat.isFile() && !stat.isSymbolicLink()) throw new Error(`unsupported source file: ${path}`);
      files[path] = stableHash({ mode: stat.mode & 0o777, link: stat.isSymbolicLink(), content: stat.isSymbolicLink() ? await readlink(join(root, path)) : (await readFile(join(root, path))).toString("base64") });
    } catch (error) {
      if (error.code !== "ENOENT") throw error;
      files[path] = null;
    }
  }
  const source = { root, head, indexHash: stableHash(index), files };
  return { ...source, fingerprint: stableHash(source) };
}

export function assertSource(expected, actual) {
  if (!expected || expected.fingerprint !== actual.fingerprint) throw new Error("Source changed since checkpoint; reconcile the checkout and create a new run. Completed work will not be replayed against a different tree.");
}
