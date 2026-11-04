// Shared templates remain portable DAGs. Pi adds explicit stop/continue routes.
export function routeTemplate(source) {
  if (source.nodes.some((node) => node.routes)) return source;
  const pending = [...source.nodes];
  const ordered = [];
  while (pending.length) {
    const index = pending.findIndex((node) => (node.dependsOn ?? []).every((id) => ordered.some((prior) => prior.id === id)));
    if (index < 0) throw new Error("template has cyclic or missing dependencies");
    ordered.push(pending.splice(index, 1)[0]);
  }
  return { ...source, entry: ordered[0]?.id, nodes: ordered.map((node, index) => {
    const next = ordered[index + 1]?.id ?? "needs_user";
    const review = ["reviewer", "security-reviewer"].includes(node.agent);
    return { ...node, routes: node.agent === "verifier" ? [] : review
      ? [{ id: "accepted", to: next, when: { decision: "accept" } }, { id: "stop", to: "needs_user" }]
      : [{ id: "continue", to: next }] };
  }) };
}
