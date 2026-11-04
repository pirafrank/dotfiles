import { readFileSync } from "node:fs";
import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { parseAliases, wrapAliasSubmit } from "./aliases.mjs";

export default function registerAliases(pi: ExtensionAPI) {
  const aliases = parseAliases(JSON.parse(readFileSync(new URL("./aliases.json", import.meta.url), "utf8")));

  pi.on("session_start", async (_event, ctx) => {
    if (!ctx.hasUI) return;
    const previousFactory = ctx.ui.getEditorComponent();
    ctx.ui.setEditorComponent((tui, theme, keybindings) => {
      const editor = previousFactory
        ? previousFactory(tui, theme, keybindings)
        : new CustomEditor(tui, theme, keybindings);
      return wrapAliasSubmit(editor, aliases);
    });
  });
}
