// Ambient types for pi extensions — editor intellisense only.
// Lives outside extensions/ so pi never loads it as an extension.
// Extensions reference it with: /// <reference path="../types/pi.d.ts" />
// No runtime import is used, so nothing needs resolving when pi runs the .ts.

type PiThinkingLevel =
  | "off"
  | "minimal"
  | "low"
  | "medium"
  | "high"
  | "xhigh"
  | "max";

type PiThemeToken =
  | "accent" | "border" | "borderAccent" | "borderMuted"
  | "success" | "error" | "warning" | "muted" | "dim" | "text"
  | "thinkingText" | "selectedBg" | "toolTitle" | "toolOutput"
  | "mdHeading" | "mdLink" | "mdCode" | "syntaxKeyword" | "syntaxString"
  | "thinkingOff" | "thinkingMinimal" | "thinkingLow" | "thinkingMedium"
  | "thinkingHigh" | "thinkingXhigh" | "thinkingMax" | "bashMode"
  | (string & {});

interface PiTheme {
  fg(token: PiThemeToken, text: string): string;
  bg(token: PiThemeToken, text: string): string;
  bold(text: string): string;
}

interface PiFooterData {
  getGitBranch(): string | undefined;
}

interface PiFooterComponent {
  render(width: number): string[];
  invalidate(): void;
}

interface PiContextUsage {
  tokens: number;
  maxTokens?: number;
  percentage?: number;
}

interface PiWidgetOptions {
  placement?: "aboveEditor" | "belowEditor";
}

interface PiUI {
  theme: PiTheme;
  setFooter(
    factory:
      | ((tui: unknown, theme: PiTheme, footerData: PiFooterData) => PiFooterComponent)
      | undefined,
  ): void;
  setStatus(id: string, text: string | undefined): void;
  setWidget(
    id: string,
    lines: string[] | ((tui: unknown, theme: PiTheme) => unknown) | undefined,
    options?: PiWidgetOptions,
  ): void;
  setWorkingIndicator(opts?: { frames: string[]; intervalMs?: number }): void;
  notify(message: string, level?: "info" | "warning" | "error"): void;
}

interface PiModel {
  id: string;
  provider?: string;
  contextLength?: number;
}

interface PiSessionManager {
  getEntries(): unknown[];
}

interface PiContext {
  ui: PiUI;
  model?: PiModel;
  thinkingLevel: PiThinkingLevel;
  cwd: string;
  hasUI: boolean;
  mode: "tui" | "rpc" | "json" | "print";
  sessionManager: PiSessionManager;
  getContextUsage(): PiContextUsage | undefined;
}

interface PiToolEndEvent {
  toolCallId: string;
  toolName: string;
  result?: unknown;
  isError?: boolean;
}

interface PiToolCallEvent {
  toolCallId: string;
  toolName: string;
  params?: Record<string, unknown>;
  arguments?: Record<string, unknown>;
}

interface PiSessionStartEvent {
  reason: "startup" | "reload" | "new" | "resume" | "fork";
  previousSessionFile?: string;
}

interface PiInputEvent {
  text: string;
  images?: unknown[];
  source: "interactive" | "rpc" | "extension";
}

type PiEventMap = {
  session_start: PiSessionStartEvent;
  session_shutdown: unknown;
  agent_end: { messages?: unknown[] };
  agent_settled: unknown;
  turn_end: unknown;
  message_start: { message: unknown };
  message_end: { message: unknown };
  input: PiInputEvent;
  tool_call: PiToolCallEvent;
  tool_execution_end: PiToolEndEvent;
  model_select: unknown;
};

interface PiExtensionAPI {
  on<K extends keyof PiEventMap>(
    event: K,
    handler: (event: PiEventMap[K], ctx: PiContext) => void | Promise<void> | any,
  ): void;
  exec(command: string[] | string): Promise<{ stdout: string; stderr: string; code: number }>;
  events: { emit(name: string, payload?: unknown): void };
}
