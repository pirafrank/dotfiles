// Config entries map an existing command name to its alias, without slashes.
export function parseAliases(config) {
  if (!config || typeof config !== "object" || Array.isArray(config)) {
    throw new Error("Alias configuration must be a JSON object");
  }
  const aliases = new Map();
  for (const [command, alias] of Object.entries(config)) {
    if (!/^[a-zA-Z0-9_-]+$/.test(command) || typeof alias !== "string" || !/^[a-zA-Z0-9_-]+$/.test(alias)) {
      throw new Error("Alias commands and names must be nonempty names without slashes or spaces");
    }
    if (aliases.has(alias)) throw new Error(`Duplicate alias: ${alias}`);
    aliases.set(alias, command);
  }
  return aliases;
}

export function expandAlias(text, aliases) {
  const match = /^(\/?)([^\s/]+)([\s\S]*)$/.exec(text.trim());
  const command = match && aliases.get(match[2]);
  return command ? `/${command}${match[3]}` : text;
}

// Pi assigns onSubmit when installing an editor and again after startup.
// Wrap every assignment so aliases reach the normal built-in command dispatcher.
export function wrapAliasSubmit(editor, aliases) {
  let submit = editor.onSubmit;
  Object.defineProperty(editor, "onSubmit", {
    configurable: true,
    enumerable: true,
    get: () => submit && ((text) => submit.call(editor, expandAlias(text, aliases))),
    set: (handler) => { submit = handler; },
  });
  return editor;
}
