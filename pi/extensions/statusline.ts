/// <reference path="../types/pi.d.ts" />
// Custom footer statusline:
//   model thinking  ·  ⎇ branch ✔/✘  ·  ctx NN%  ·  NN.Nk tok
// Async git state is cached and read synchronously by render().

export default function (pi: PiExtensionAPI) {
  let gitDirty: boolean | null = null;

  async function refreshGit(ctx: PiContext): Promise<void> {
    try {
      const res = await pi.exec(["git", "-C", ctx.cwd, "status", "--porcelain"]);
      gitDirty = res.code === 0 ? res.stdout.trim().length > 0 : null;
    } catch {
      gitDirty = null;
    }
  }

  function fmtTokens(n: number): string {
    return n < 1000 ? `${n}` : `${(n / 1000).toFixed(1)}k`;
  }

  function thinkingToken(lvl: PiThinkingLevel): PiThemeToken {
    const map: Record<PiThinkingLevel, PiThemeToken> = {
      off: "thinkingOff",
      minimal: "thinkingMinimal",
      low: "thinkingLow",
      medium: "thinkingMedium",
      high: "thinkingHigh",
      xhigh: "thinkingXhigh",
      max: "thinkingMax",
    };
    return map[lvl] ?? "thinkingText";
  }

  function install(ctx: PiContext): void {
    ctx.ui.setWorkingIndicator({
      frames: [
        ctx.ui.theme.fg("dim", "·"),
        ctx.ui.theme.fg("muted", "•"),
        ctx.ui.theme.fg("accent", "●"),
        ctx.ui.theme.fg("muted", "•"),
      ],
      intervalMs: 140,
    });

    ctx.ui.setFooter((_tui, theme, footerData) => ({
      render(_width: number): string[] {
        const sep = theme.fg("dim", "  ·  ");
        const parts: string[] = [];

        // model + thinking level
        const model = ctx.model?.id ?? "no model";
        const lvl = ctx.thinkingLevel;
        parts.push(theme.fg("accent", model) + theme.fg(thinkingToken(lvl), ` ${lvl}`));

        // git branch + dirty marker
        const branch = footerData.getGitBranch();
        if (branch) {
          const mark =
            gitDirty === null
              ? ""
              : gitDirty
                ? theme.fg("warning", " ✘")
                : theme.fg("success", " ✔");
          parts.push(theme.fg("muted", `⎇ ${branch}`) + mark);
        }

        // context usage
        const usage = ctx.getContextUsage();
        if (usage) {
          const max = usage.maxTokens ?? ctx.model?.contextLength;
          const pct =
            usage.percentage ??
            (max ? Math.round((usage.tokens / max) * 100) : undefined);
          if (pct !== undefined) {
            const tok = pct >= 90 ? "error" : pct >= 70 ? "warning" : "success";
            parts.push(theme.fg("muted", "ctx ") + theme.fg(tok, `${pct}%`));
          }
          parts.push(theme.fg("dim", `${fmtTokens(usage.tokens)} tok`));
        }

        return [parts.join(sep)];
      },
      invalidate() {},
    }));
  }

  pi.on("session_start", async (_e, ctx) => {
    if (!ctx.hasUI) return; // no TUI footer in rpc/print (e.g. inside Zed)
    await refreshGit(ctx);
    install(ctx);
  });
  pi.on("turn_end", async (_e, ctx) => {
    if (!ctx.hasUI) return;
    await refreshGit(ctx);
  });
  pi.on("tool_execution_end", async (_e, ctx) => {
    if (!ctx.hasUI) return;
    await refreshGit(ctx);
  });
}
