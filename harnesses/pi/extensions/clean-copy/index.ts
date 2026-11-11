import { type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { TuiAltScreen } from "@earendil-works/pi-tui";

type ClipboardMethod = (text: string) => Promise<boolean>;
type CopyablePrototype = {
	copyTextToClipboard: ClipboardMethod;
	__cleanCopyOriginal?: ClipboardMethod;
	__cleanCopyEnabled?: boolean;
};

const prototype = TuiAltScreen.prototype as unknown as CopyablePrototype;

// Pi's fullscreen selection handler calls this method with the selected text.
// Keep the original method so runtime toggles and extension reloads do not stack wrappers.
if (!prototype.__cleanCopyOriginal) {
	prototype.__cleanCopyOriginal = prototype.copyTextToClipboard;
	prototype.__cleanCopyEnabled = true;
	prototype.copyTextToClipboard = function (text) {
		const cleaned = prototype.__cleanCopyEnabled
			? text.replace(/^ /gm, "")
			: text;
		return prototype.__cleanCopyOriginal!.call(this, cleaned);
	};
}

export default function registerCleanCopy(pi: ExtensionAPI) {
	pi.registerCommand("clean-copy", {
		description: "Remove one leading space per line from fullscreen mouse selections (on|off)",
		handler: async (args, ctx) => {
			const option = args.trim().toLowerCase();
			if (option === "on") prototype.__cleanCopyEnabled = true;
			else if (option === "off") prototype.__cleanCopyEnabled = false;
			else if (option) {
				ctx.ui.notify("Usage: /clean-copy [on|off]", "warning");
				return;
			}
			ctx.ui.notify(`Clean selection copy ${prototype.__cleanCopyEnabled ? "on" : "off"}`, "info");
		},
	});
}
