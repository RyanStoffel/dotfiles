import { existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { homedir } from "node:os";
import { basename, dirname, join, relative } from "node:path";
import type {
  ExtensionAPI,
  ExtensionContext,
  ReadonlyFooterDataProvider,
} from "@earendil-works/pi-coding-agent";
import {
  getCapabilities,
  hyperlink,
  truncateToWidth,
  visibleWidth,
} from "@earendil-works/pi-tui";
import {
  emptyGitInfoState,
  emptyModelInfoState,
  GIT_INFO_CHANNEL,
  MODEL_INFO_CHANNEL,
  REFRESH_CHANNEL,
  isGitInfoState,
  isModelInfoState,
} from "../shared/dashboard-state.ts";

type Rgb = [number, number, number];
interface RenderableNode {
  children?: RenderableNode[];
  invalidate(): void;
  render(width: number): string[];
}

interface DashboardTui extends RenderableNode {
  requestRender(force?: boolean): void;
}

const RESET = "\x1b[0m";
const BOLD = "\x1b[1m";
const PALETTE: Rgb[] = [
  [167, 192, 128],
  [147, 187, 127],
  [131, 192, 146],
  [127, 187, 179],
];
const TITLE_LINES = [
  "  ██████╗  ██╗ ",
  "  ██╔══██╗ ██║ ",
  "  ██████╔╝ ██║ ",
  "  ██╔═══╝  ██║ ",
  "  ██║      ██║ ",
  "  ╚═╝      ╚═╝ ",
];
const ANSI_PATTERN =
  /[\u001B\u009B][[\]()#;?]*(?:(?:(?:[a-zA-Z\d]*(?:;[a-zA-Z\d]*)*)?\u0007)|(?:(?:\d{1,4}(?:;\d{0,4})*)?[\dA-PR-TZcf-nq-uy=><~]))/g;
// eslint-disable-next-line no-control-regex
const OSC_PATTERN =
  /(?:\u001b\]|\u009d)(?:[^\u0007\u001b\u009c]|\u001b(?!\\))*(?:\u0007|\u001b\\|\u009c)/g;
// eslint-disable-next-line no-control-regex
const CSI_PATTERN = /(?:\u001b\[|\u009b)[0-?]*[ -/]*[@-~]/g;
// eslint-disable-next-line no-control-regex
const ESCAPE_PATTERN = /\u001b(?:[()][0-2A-Z]|[ -/]*[@-~])/g;

function sanitizeTerminalLabel(text: string) {
  return text
    .replace(OSC_PATTERN, "")
    .replace(CSI_PATTERN, "")
    .replace(ESCAPE_PATTERN, "")
    .replace(/[\u0000-\u001f\u007f-\u009f]/g, "");
}

function mix(a: number, b: number, amount: number) {
  return Math.round(a + (b - a) * amount);
}

function sampleGradient(position: number) {
  const wrapped = ((position % 1) + 1) % 1;
  const scaled = wrapped * PALETTE.length;
  const index = Math.floor(scaled);
  const nextIndex = (index + 1) % PALETTE.length;
  const amount = scaled - index;
  const start = PALETTE[index]!;
  const end = PALETTE[nextIndex]!;

  return [
    mix(start[0], end[0], amount),
    mix(start[1], end[1], amount),
    mix(start[2], end[2], amount),
  ] satisfies Rgb;
}

function foreground([red, green, blue]: Rgb, text: string) {
  return `\x1b[38;2;${red};${green};${blue}m${text}${RESET}`;
}

function gradientText(text: string, phase: number) {
  const characters = [...text];
  const span = Math.max(characters.length - 1, 1);

  return characters
    .map((character, index) =>
      character === " "
        ? character
        : foreground(sampleGradient(index / span + phase), character),
    )
    .join("");
}

function hasChildren(
  component: RenderableNode,
): component is RenderableNode & { children: RenderableNode[] } {
  return Array.isArray(component.children);
}

function renderedText(component: RenderableNode) {
  try {
    return component.render(200).join("\n").replace(ANSI_PATTERN, "");
  } catch {
    return "";
  }
}

function hideThemesSection(component: RenderableNode) {
  if (!hasChildren(component)) return false;

  for (let index = 0; index < component.children.length; index += 1) {
    const child = component.children[index]!;
    const firstLine = renderedText(child)
      .split("\n")
      .find((line) => line.trim())
      ?.trim();

    if (firstLine === "[Themes]") {
      const removeCount =
        component.children[index + 1] &&
        renderedText(component.children[index + 1]!).trim() === ""
          ? 2
          : 1;
      component.children.splice(index, removeCount);
      component.invalidate();
      return true;
    }

    if (hideThemesSection(child)) return true;
  }

  return false;
}

function formatTokens(tokens: number) {
  if (tokens < 1_000) return `${tokens}`;
  if (tokens < 1_000_000) return `${Math.round(tokens / 1_000)}k`;
  return `${(tokens / 1_000_000).toFixed(1)}m`;
}

function formatDirectory(cwd: string) {
  const home = homedir();
  if (cwd === home) return "~";
  const display = cwd.startsWith(`${home}/`) ? `~/${relative(home, cwd)}` : cwd;
  return sanitizeTerminalLabel(display);
}

function center(text: string, width: number) {
  const padding = Math.max(0, Math.floor((width - visibleWidth(text)) / 2));
  return truncateToWidth(`${" ".repeat(padding)}${text}`, width);
}

function columns(left: string, right: string, width: number) {
  if (!right) return truncateToWidth(left, width);

  const naturalGap = width - visibleWidth(left) - visibleWidth(right);
  if (naturalGap >= 1) return `${left}${" ".repeat(naturalGap)}${right}`;

  const leftWidth = Math.max(1, Math.floor(width * 0.45));
  const rightWidth = Math.max(1, width - leftWidth - 1);
  const fittedLeft = truncateToWidth(left, leftWidth);
  const fittedRight = truncateToWidth(right, rightWidth);
  const gap = Math.max(
    1,
    width - visibleWidth(fittedLeft) - visibleWidth(fittedRight),
  );
  return truncateToWidth(
    `${fittedLeft}${" ".repeat(gap)}${fittedRight}`,
    width,
  );
}

function discoverResources(cwd: string): {
  context: string[];
  extensions: string[];
  skills: string[];
  prompts: string[];
  themes: string[];
} {
  const home = homedir();
  const agentDir = join(home, ".pi", "agent");

  function isDir(
    dir: string,
    ent: { name: string; isDirectory(): boolean; isSymbolicLink(): boolean },
  ): boolean {
    if (ent.isDirectory()) return true;
    if (ent.isSymbolicLink()) {
      try {
        return statSync(join(dir, ent.name)).isDirectory();
      } catch {
        return false;
      }
    }
    return false;
  }

  function isFile(
    dir: string,
    ent: { name: string; isFile(): boolean; isSymbolicLink(): boolean },
  ): boolean {
    if (ent.isFile()) return true;
    if (ent.isSymbolicLink()) {
      try {
        return statSync(join(dir, ent.name)).isFile();
      } catch {
        return false;
      }
    }
    return false;
  }

  // 1. Context Files
  const contextSet = new Set<string>();
  const globalAgents = join(agentDir, "AGENTS.md");
  if (existsSync(globalAgents)) {
    contextSet.add("AGENTS.md (global)");
  }
  let curr = cwd;
  while (curr) {
    for (const f of ["AGENTS.md", "CLAUDE.md"]) {
      const p = join(curr, f);
      if (existsSync(p) && p !== globalAgents) {
        const rel = relative(cwd, p);
        contextSet.add(rel.startsWith("..") || !rel ? basename(p) : `./${rel}`);
      }
    }
    const parent = dirname(curr);
    if (parent === curr) break;
    curr = parent;
  }

  // 2. Extensions
  const extSet = new Set<string>();
  for (const sPath of [
    join(agentDir, "settings.json"),
    join(cwd, ".pi", "settings.json"),
    join(cwd, "pi", "settings.json"),
  ]) {
    if (existsSync(sPath)) {
      try {
        const s = JSON.parse(readFileSync(sPath, "utf8"));
        if (Array.isArray(s.packages)) {
          for (const pkg of s.packages) {
            const match = pkg.match(/(?:npm:|git:.*?\/)([a-zA-Z0-9_-]+)(?:\.git|@.*)?$/);
            if (match) extSet.add(match[1]);
          }
        }
        if (Array.isArray(s.extensions)) {
          for (const extPath of s.extensions) {
            const base = basename(extPath).replace(/\.(ts|js)$/, "");
            if (base) extSet.add(base);
          }
        }
      } catch {}
    }
  }

  for (const dir of [
    join(agentDir, "extensions"),
    join(cwd, ".pi", "extensions"),
    join(cwd, "pi", "extensions"),
  ]) {
    if (existsSync(dir)) {
      try {
        for (const ent of readdirSync(dir, { withFileTypes: true })) {
          if (ent.name.startsWith(".") || ent.name === "node_modules" || ent.name === "shared") continue;
          if (isDir(dir, ent)) {
            extSet.add(ent.name);
          } else if (isFile(dir, ent) && (ent.name.endsWith(".ts") || ent.name.endsWith(".js"))) {
            extSet.add(ent.name.replace(/\.(ts|js)$/, ""));
          }
        }
      } catch {}
    }
  }

  // 3. Skills
  const skillSet = new Set<string>();
  function scanSkills(dir: string) {
    if (!existsSync(dir)) return;
    try {
      for (const ent of readdirSync(dir, { withFileTypes: true })) {
        if (ent.name.startsWith(".")) continue;
        const fullPath = join(dir, ent.name);
        if (isDir(dir, ent)) {
          if (existsSync(join(fullPath, "SKILL.md"))) {
            skillSet.add(ent.name);
          } else {
            scanSkills(fullPath);
          }
        } else if (isFile(dir, ent) && ent.name.endsWith(".md") && ent.name !== "README.md") {
          skillSet.add(ent.name.replace(/\.md$/, ""));
        }
      }
    } catch {}
  }

  scanSkills(join(agentDir, "skills"));
  scanSkills(join(home, ".agents", "skills"));
  scanSkills(join(cwd, ".pi", "skills"));
  scanSkills(join(cwd, "pi", "skills"));
  scanSkills(join(cwd, ".agents", "skills"));
  scanSkills(join(cwd, "skills"));

  const nmDir = join(agentDir, "npm", "node_modules");
  if (existsSync(nmDir)) {
    try {
      for (const pkg of readdirSync(nmDir)) {
        if (pkg.startsWith("@")) {
          const scopeDir = join(nmDir, pkg);
          for (const subPkg of readdirSync(scopeDir)) {
            scanSkills(join(scopeDir, subPkg, "skills"));
          }
        } else {
          scanSkills(join(nmDir, pkg, "skills"));
        }
      }
    } catch {}
  }

  // 4. Prompts
  const promptSet = new Set<string>();
  function scanPrompts(dir: string) {
    if (!existsSync(dir)) return;
    try {
      for (const ent of readdirSync(dir, { withFileTypes: true })) {
        if (ent.name.startsWith(".")) continue;
        const fullPath = join(dir, ent.name);
        if (isDir(dir, ent)) {
          scanPrompts(fullPath);
        } else if (isFile(dir, ent) && (ent.name.endsWith(".md") || ent.name.endsWith(".prompt"))) {
          promptSet.add(`/${ent.name.replace(/\.(md|prompt)$/, "")}`);
        }
      }
    } catch {}
  }
  scanPrompts(join(agentDir, "prompts"));
  scanPrompts(join(cwd, ".pi", "prompts"));
  scanPrompts(join(cwd, "pi", "prompts"));
  scanPrompts(join(cwd, "prompts"));

  // 5. Themes
  const themeSet = new Set<string>();
  function scanThemes(dir: string) {
    if (!existsSync(dir)) return;
    try {
      for (const ent of readdirSync(dir, { withFileTypes: true })) {
        if (ent.name.startsWith(".") || ent.name === "theme-schema.json") continue;
        if (isFile(dir, ent) && ent.name.endsWith(".json")) {
          themeSet.add(ent.name.replace(/\.json$/, ""));
        }
      }
    } catch {}
  }
  scanThemes(join(agentDir, "themes"));
  scanThemes(join(cwd, ".pi", "themes"));
  scanThemes(join(cwd, "pi", "themes"));

  return {
    context: Array.from(contextSet).sort(),
    extensions: Array.from(extSet).sort(),
    skills: Array.from(skillSet).sort(),
    prompts: Array.from(promptSet).sort(),
    themes: Array.from(themeSet).sort(),
  };
}

function formatResourceLines(
  resources: ReturnType<typeof discoverResources>,
  theme: { fg(token: string, text: string): string },
  width: number,
): string[] {
  const rawSections: Array<{ label: string; items: string[] }> = [
    { label: "Context", items: resources.context },
    { label: "Extensions", items: resources.extensions },
    { label: "Skills", items: resources.skills },
    { label: "Prompts", items: resources.prompts },
    { label: "Themes", items: resources.themes },
  ];

  const sections = rawSections.filter((s) => s.items.length > 0);
  if (sections.length === 0) return [];

  // Calculate maximum label length for uniform vertical column alignment
  let maxLabelVisLen = 14;
  for (const { label, items } of sections) {
    const rawLen = 2 + label.length + 1 + String(items.length).length + 2; // "  Label (count)"
    if (rawLen > maxLabelVisLen) maxLabelVisLen = rawLen;
  }
  const colWidth = maxLabelVisLen + 1;

  const divider = theme.fg("borderMuted", "│ ");
  const dividerVisLen = 2;
  const leftIndent = colWidth + dividerVisLen;
  const maxContentWidth = Math.max(20, width - leftIndent - 2);

  const dotSep = theme.fg("dim", " · ");
  const dotSepVisLen = 3;

  const lines: string[] = [];

  for (const { label, items } of sections) {
    const labelTitle = `${BOLD}${theme.fg("accent", label)}${RESET}`;
    const countStr = theme.fg("dim", `(${items.length})`);
    const rawLabelVis = 2 + label.length + 1 + String(items.length).length + 2;
    const padding = " ".repeat(Math.max(0, colWidth - rawLabelVis));

    const headerPrefix = `  ${labelTitle} ${countStr}${padding}${divider}`;
    const continuationPrefix = `${" ".repeat(colWidth)}${divider}`;

    const sectionLines: string[] = [];
    let currentLineItems: string[] = [];
    let currentVisLen = 0;

    for (const item of items) {
      let itemFormatted = theme.fg("muted", item);
      let itemVisLen = visibleWidth(item);

      if (item.endsWith(" (global)")) {
        const base = item.slice(0, -" (global)".length);
        itemFormatted = `${theme.fg("muted", base)} ${theme.fg("dim", "(global)")}`;
        itemVisLen = visibleWidth(item);
      }

      if (currentLineItems.length === 0) {
        currentLineItems.push(itemFormatted);
        currentVisLen = itemVisLen;
      } else if (currentVisLen + dotSepVisLen + itemVisLen <= maxContentWidth) {
        currentLineItems.push(itemFormatted);
        currentVisLen += dotSepVisLen + itemVisLen;
      } else {
        const prefix = sectionLines.length === 0 ? headerPrefix : continuationPrefix;
        sectionLines.push(prefix + currentLineItems.join(dotSep));
        currentLineItems = [itemFormatted];
        currentVisLen = itemVisLen;
      }
    }

    if (currentLineItems.length > 0) {
      const prefix = sectionLines.length === 0 ? headerPrefix : continuationPrefix;
      sectionLines.push(prefix + currentLineItems.join(dotSep));
    }

    lines.push(...sectionLines);
  }

  return lines;
}

export default function uiCustomization(pi: ExtensionAPI) {
  let title = "pi";
  let modelInfo = emptyModelInfoState();
  let gitInfo = emptyGitInfoState();
  let requestRender: (() => void) | undefined;
  let activeTui: DashboardTui | undefined;
  let themeRemovalTimers: Array<ReturnType<typeof setTimeout>> = [];

  const stopModelListener = pi.events.on(MODEL_INFO_CHANNEL, (value) => {
    if (!isModelInfoState(value)) return;
    modelInfo = value;
    requestRender?.();
  });

  const stopGitListener = pi.events.on(GIT_INFO_CHANNEL, (value) => {
    if (!isGitInfoState(value)) return;
    gitInfo = value;
    requestRender?.();
  });

  function scheduleThemeRemoval(tui: DashboardTui) {
    for (const timer of themeRemovalTimers) clearTimeout(timer);
    themeRemovalTimers = [];

    for (const delay of [0, 50, 250, 1_000]) {
      themeRemovalTimers.push(
        setTimeout(() => {
          if (hideThemesSection(tui)) tui.requestRender(true);
        }, delay),
      );
    }
  }

  function install(ctx: ExtensionContext) {
    if (ctx.mode !== "tui") return;

    ctx.ui.setHeader((tui) => {
      activeTui = tui;
      requestRender = () => tui.requestRender();
      scheduleThemeRemoval(tui);

      return {
        render(width: number) {
          const art = TITLE_LINES.map((line, row) =>
            center(gradientText(line, row * 0.045), width),
          );
          const subtitle = center(
            `${BOLD}${gradientText(title, 0.18)}${RESET}`,
            width,
          );
          const resources = discoverResources(ctx.cwd);
          const resourceLines = formatResourceLines(resources, ctx.ui.theme, width);
          return ["", ...art, subtitle, "", ...resourceLines, ""];
        },
        invalidate() {},
      };
    });

    ctx.ui.setFooter((tui, theme, footerData: ReadonlyFooterDataProvider) => {
      requestRender = () => tui.requestRender();

      return {
        invalidate() {},
        render(width: number) {
          const directory = theme.fg("text", formatDirectory(ctx.cwd));
          const fileLabel = gitInfo.changedFiles === 1 ? "file" : "files";
          let git = gitInfo.branch
            ? `${gitInfo.branch} · ${gitInfo.changedFiles} ${fileLabel} changed`
            : "";

          if (gitInfo.pullRequest) {
            const prLabel = `PR #${gitInfo.pullRequest.number}`;
            const linkedPr = getCapabilities().hyperlinks
              ? hyperlink(prLabel, gitInfo.pullRequest.url)
              : prLabel;
            git += ` · ${linkedPr}`;
          }

          const contextPercent =
            modelInfo.contextPercent === null
              ? "?"
              : `${Math.round(modelInfo.contextPercent)}`;
          const contextWindow =
            modelInfo.contextWindow > 0
              ? formatTokens(modelInfo.contextWindow)
              : "?";
          const tps =
            modelInfo.tokensPerSecond === null
              ? "— tok/s"
              : `${Math.round(modelInfo.tokensPerSecond)} tok/s`;
          const usage = `${contextPercent}%/${contextWindow} · $${modelInfo.cost.toFixed(2)} · ${tps}`;
          const rawModelId = modelInfo.modelId;
          const modelIdWithoutProvider = rawModelId.includes("/")
            ? rawModelId.split("/").slice(1).join("/")
            : rawModelId;
          const model =
            rawModelId === "no-model"
              ? rawModelId
              : `${modelIdWithoutProvider} · ${modelInfo.thinking}`;

          const lines = [
            columns(directory, theme.fg("muted", model), width),
            columns(theme.fg("muted", usage), theme.fg("muted", git), width),
          ];

          // Extension statuses render after the two dashboard lines, one per row.
          const statuses = footerData.getExtensionStatuses();
          const statusLines = Array.from(statuses.entries())
            .sort(([a], [b]) => a.localeCompare(b))
            .flatMap(([, text]) => text.split("\n"));
          for (const statusLine of statusLines) {
            lines.push(
              truncateToWidth(statusLine, width, theme.fg("dim", "...")),
            );
          }

          return lines;
        },
      };
    });

    ctx.ui.setTitle(`pi · ${title}`);
    pi.events.emit(REFRESH_CHANNEL, undefined);
  }

  pi.on("session_start", (_event, ctx) => {
    title = formatDirectory(ctx.cwd);
    modelInfo = emptyModelInfoState();
    gitInfo = emptyGitInfoState();
    install(ctx);
  });

  pi.on("resources_discover", () => {
    if (activeTui) scheduleThemeRemoval(activeTui);
  });

  pi.on("session_shutdown", (_event, ctx) => {
    stopModelListener();
    stopGitListener();
    for (const timer of themeRemovalTimers) clearTimeout(timer);
    themeRemovalTimers = [];
    activeTui = undefined;
    requestRender = undefined;
    if (ctx.mode === "tui") {
      ctx.ui.setHeader(undefined);
      ctx.ui.setFooter(undefined);
    }
  });
}
