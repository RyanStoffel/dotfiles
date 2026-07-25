/// <reference path="../types/pi.d.ts" />
// Polished blank-session splash: an Everforest-tinted "Pi" logo shown above the
// editor when a session has no messages yet. Cleared on the first input.

export default function (pi: PiExtensionAPI) {
  const WIDGET = "pi-splash";

  // Block-letter "Pi" wordmark. Rendered with a top-down Everforest gradient.
  const art = [
    " ██████╗ ██╗",
    " ██╔══██╗██║",
    " ██████╔╝██║",
    " ██╔═══╝ ██║",
    " ██║     ██║",
    " ╚═╝     ╚═╝",
  ];
  // aqua -> green -> blue gradient down the glyph.
  const gradient: PiThemeToken[] = [
    "accent",
    "accent",
    "success",
    "success",
    "mdLink",
    "mdLink",
  ];

  function isBlank(ctx: PiContext): boolean {
    return ctx.sessionManager.getEntries().length === 0;
  }

  function show(ctx: PiContext): void {
    const t = ctx.ui.theme;
    const lines: string[] = [
      "",
      ...art.map((line, i) => "   " + t.fg(gradient[i] ?? "accent", line)),
      "",
      "   " + t.bold(t.fg("text", "pi")) + t.fg("muted", "  ·  coding agent"),
      "   " +
        t.fg("dim", "type to begin") +
        t.fg("border", "  ·  ") +
        t.fg("dim", "/help") +
        t.fg("border", "  ·  ") +
        t.fg("dim", "ctrl+p switch model"),
      "",
    ];
    ctx.ui.setWidget(WIDGET, lines, { placement: "aboveEditor" });
  }

  function clear(ctx: PiContext): void {
    ctx.ui.setWidget(WIDGET, undefined);
  }

  pi.on("session_start", async (_e, ctx) => {
    if (!ctx.hasUI) return;
    if (isBlank(ctx)) show(ctx);
    else clear(ctx);
  });

  // Remove the splash as soon as the user engages.
  pi.on("input", async (_e, ctx) => {
    if (ctx.hasUI) clear(ctx);
  });
  pi.on("message_start", async (_e, ctx) => {
    if (ctx.hasUI) clear(ctx);
  });
}
