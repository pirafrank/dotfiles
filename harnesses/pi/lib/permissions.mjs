const ASK_PATTERNS = [
  /\b(?:git\s+(?:commit|amend|push|reset|clean)|rm\s+-[A-Za-z]*r|sudo\b|(?:npm|pnpm|yarn|bun|cargo|pip|uv)\s+(?:install|add)|(?:cargo|npm)\s+publish|gh\s+pr\s+create|terraform\s+apply|kubectl\s+apply)\b/i,
  /(?:^|\s)(?:>|>>|\|\s*(?:sh|bash|zsh))/
];

export function classifyBash(command) {
  if (typeof command !== "string" || !command.trim()) return { action: "ask", reason: "empty or invalid shell command" };
  if (ASK_PATTERNS.some((pattern) => pattern.test(command))) return { action: "ask", reason: "external, destructive, install, or ambiguous shell operation" };
  return { action: "allow", reason: "local command not matched by a protected operation" };
}

export function classifyToolCall(toolName, input = {}) {
  if (toolName === "bash") return classifyBash(input.command);
  return { action: "allow", reason: ["read", "grep", "find", "ls"].includes(toolName) ? "read-only tool" : "scoped built-in tool" };
}
