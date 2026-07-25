/// <reference path="../types/pi.d.ts" />
// Best-effort format-after-edit: when an edit/write tool touches a file, run the
// matching formatter for Ryan's stack IF it's available. Silent no-op otherwise,
// so it never blocks or errors a turn.

export default function (pi: PiExtensionAPI) {
  const paths = new Map<string, string>(); // toolCallId -> file path
  const available = new Map<string, boolean>();

  const EDIT_TOOLS = new Set([
    "edit",
    "write",
    "str_replace",
    "str_replace_editor",
    "create",
    "multiedit",
    "apply_patch",
  ]);

  async function onPath(bin: string): Promise<boolean> {
    if (available.has(bin)) return available.get(bin)!;
    let ok = false;
    try {
      ok = (await pi.exec(["which", bin])).code === 0;
    } catch {
      /* ignore */
    }
    available.set(bin, ok);
    return ok;
  }

  function extractPath(ev: PiToolCallEvent): string | undefined {
    const p = (ev.params ?? ev.arguments ?? {}) as Record<string, unknown>;
    const keys = ["path", "file_path", "filePath", "file", "filename"];
    for (const k of keys) {
      const v = p[k];
      if (typeof v === "string" && v.length) return v;
    }
    for (const v of Object.values(p)) {
      if (typeof v === "string" && v.includes("/") && /\.[a-zA-Z0-9]+$/.test(v)) return v;
    }
    return undefined;
  }

  // Ordered formatter candidates per extension (first available wins).
  function candidatesFor(file: string): { bin: string; argv: string[] }[] {
    const ext = file.split(".").pop()?.toLowerCase() ?? "";
    const P = (bin: string, ...rest: string[]) => ({ bin, argv: [bin, ...rest, file] });
    switch (ext) {
      case "ts": case "tsx": case "js": case "jsx": case "mjs": case "cjs":
      case "json": case "css": case "scss": case "html": case "md":
        // project-local prettier only (no download); skips cleanly if absent
        return [{ bin: "npx", argv: ["npx", "--no-install", "prettier", "--write", file] }];
      case "py":
        return [P("ruff", "format"), P("black")];
      case "nix":
        return [P("nixpkgs-fmt")];
      case "go":
        return [P("gofmt", "-w")];
      case "rs":
        return [P("rustfmt")];
      case "dart":
        return [{ bin: "dart", argv: ["dart", "format", file] }];
      case "swift":
        return [P("swift-format", "-i")];
      case "java":
        return [P("google-java-format", "-i")];
      default:
        return [];
    }
  }

  pi.on("tool_call", async (e) => {
    if (!e.toolCallId || !EDIT_TOOLS.has(String(e.toolName))) return;
    const p = extractPath(e);
    if (p) paths.set(e.toolCallId, p);
  });

  pi.on("tool_execution_end", async (e, ctx) => {
    const file = paths.get(e.toolCallId);
    paths.delete(e.toolCallId);
    if (!file || e.isError) return;

    const target = file.startsWith("/") ? file : `${ctx.cwd}/${file}`;
    for (const cand of candidatesFor(file)) {
      if (!(await onPath(cand.bin))) continue;
      const argv = cand.argv.map((a) => (a === file ? target : a));
      try {
        await pi.exec(argv);
      } catch {
        /* ignore */
      }
      return; // first available formatter wins
    }
  });
}
