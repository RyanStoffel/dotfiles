/// <reference path="../types/pi.d.ts" />
// Notify when the agent finishes: a macOS desktop notification (works in the
// terminal and inside Zed) plus a terminal bell (TUI only, so it never corrupts
// the rpc stream). Debounced so a burst of runs notifies once.

export default function (pi: PiExtensionAPI) {
  let last = 0;
  let osascript: boolean | null = null;

  async function hasOsascript(): Promise<boolean> {
    if (osascript !== null) return osascript;
    try {
      const r = await pi.exec(["which", "osascript"]);
      osascript = r.code === 0;
    } catch {
      osascript = false;
    }
    return osascript;
  }

  pi.on("agent_settled", async (_e, ctx) => {
    const now = Date.now();
    if (now - last < 3000) return; // debounce bursts
    last = now;

    if (ctx.hasUI) {
      try {
        process.stdout.write("\x07"); // BEL — visual/audible bell per terminal
      } catch {
        /* ignore */
      }
    }

    if (await hasOsascript()) {
      const proj = ctx.cwd.split("/").pop() || "pi";
      try {
        await pi.exec([
          "osascript",
          "-e",
          `display notification "Done in ${proj}" with title "pi" sound name "Tink"`,
        ]);
      } catch {
        /* ignore */
      }
    }
  });
}

// `process` exists in pi's Node-compatible runtime; guarded above just in case.
declare const process: { stdout: { write(s: string): void } };
