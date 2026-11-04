export function validatePackages(lock, settings) {
  if (lock?.version !== 1 || !Array.isArray(lock.packages)) throw new Error("invalid packages.lock.json");
  for (const spec of lock.packages) {
    if (typeof spec !== "string" || !/^npm:(?:@[a-z0-9_.-]+\/)?[a-z0-9_.-]+@\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?$/.test(spec)) throw new Error(`package must be exact: ${spec}`);
  }
  if (new Set(lock.packages).size !== lock.packages.length) throw new Error("duplicate approved package");
  const configured = settings?.packages?.map((entry) => typeof entry === "string" ? entry : entry?.source);
  if (!Array.isArray(configured) || configured.some((entry) => typeof entry !== "string") || JSON.stringify([...configured].sort()) !== JSON.stringify([...lock.packages].sort())) throw new Error("Pi settings packages differ from packages.lock.json");
  return lock.packages;
}
