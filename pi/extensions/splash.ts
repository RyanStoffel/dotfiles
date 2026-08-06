/// <reference path="../types/pi.d.ts" />
import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

function discoverResources(cwd: string): {
  context: string[];
  extensions: string[];
  skills: string[];
  prompts: string[];
  themes: string[];
} {
  const home = process.env.HOME || os.homedir();
  const agentDir = path.join(home, ".pi", "agent");

  function formatPath(p: string): string {
    if (home && p.startsWith(home)) {
      return `~${p.slice(home.length)}`;
    }
    return p;
  }

  function isDir(d: string, ent: fs.Dirent): boolean {
    if (ent.isDirectory()) return true;
    if (ent.isSymbolicLink()) {
      try {
        return fs.statSync(path.join(d, ent.name)).isDirectory();
      } catch {
        return false;
      }
    }
    return false;
  }

  function isFile(d: string, ent: fs.Dirent): boolean {
    if (ent.isFile()) return true;
    if (ent.isSymbolicLink()) {
      try {
        return fs.statSync(path.join(d, ent.name)).isFile();
      } catch {
        return false;
      }
    }
    return false;
  }

  // 1. Context Files
  const contextSet = new Set<string>();
  const globalAgents = path.join(agentDir, "AGENTS.md");
  if (fs.existsSync(globalAgents)) {
    contextSet.add(formatPath(globalAgents));
  }
  let curr = cwd;
  while (curr) {
    for (const f of ["AGENTS.md", "CLAUDE.md"]) {
      const p = path.join(curr, f);
      if (fs.existsSync(p) && p !== globalAgents) {
        const rel = path.relative(cwd, p);
        contextSet.add(rel.startsWith("..") || !rel ? formatPath(p) : `./${rel}`);
      }
    }
    const parent = path.dirname(curr);
    if (parent === curr) break;
    curr = parent;
  }

  // 2. Extensions
  const extSet = new Set<string>();
  for (const sPath of [path.join(agentDir, "settings.json"), path.join(cwd, ".pi", "settings.json")]) {
    if (fs.existsSync(sPath)) {
      try {
        const s = JSON.parse(fs.readFileSync(sPath, "utf8"));
        if (Array.isArray(s.packages)) {
          for (const pkg of s.packages) {
            const match = pkg.match(/(?:npm:|git:.*?\/)([a-zA-Z0-9_-]+)(?:\.git|@.*)?$/);
            if (match) extSet.add(match[1]);
          }
        }
        if (Array.isArray(s.extensions)) {
          for (const extPath of s.extensions) {
            const base = path.basename(extPath).replace(/\.(ts|js)$/, "");
            if (base) extSet.add(base);
          }
        }
      } catch {}
    }
  }

  for (const dir of [path.join(agentDir, "extensions"), path.join(cwd, ".pi", "extensions")]) {
    if (fs.existsSync(dir)) {
      try {
        for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
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
    if (!fs.existsSync(dir)) return;
    try {
      for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
        if (ent.name.startsWith(".")) continue;
        const fullPath = path.join(dir, ent.name);
        if (isDir(dir, ent)) {
          if (fs.existsSync(path.join(fullPath, "SKILL.md"))) {
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

  scanSkills(path.join(agentDir, "skills"));
  scanSkills(path.join(home, ".agents", "skills"));
  scanSkills(path.join(cwd, ".pi", "skills"));
  scanSkills(path.join(cwd, ".agents", "skills"));
  scanSkills(path.join(cwd, "skills"));

  let ancestor = path.dirname(cwd);
  while (ancestor && ancestor !== cwd && ancestor !== home) {
    scanSkills(path.join(ancestor, ".agents", "skills"));
    const parent = path.dirname(ancestor);
    if (parent === ancestor) break;
    ancestor = parent;
  }

  const nmDir = path.join(agentDir, "npm", "node_modules");
  if (fs.existsSync(nmDir)) {
    try {
      for (const pkg of fs.readdirSync(nmDir)) {
        if (pkg.startsWith("@")) {
          const scopeDir = path.join(nmDir, pkg);
          for (const subPkg of fs.readdirSync(scopeDir)) {
            scanSkills(path.join(scopeDir, subPkg, "skills"));
          }
        } else {
          scanSkills(path.join(nmDir, pkg, "skills"));
        }
      }
    } catch {}
  }

  // 4. Prompts
  const promptSet = new Set<string>();
  function scanPrompts(dir: string) {
    if (!fs.existsSync(dir)) return;
    try {
      for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
        if (ent.name.startsWith(".")) continue;
        const fullPath = path.join(dir, ent.name);
        if (isDir(dir, ent)) {
          scanPrompts(fullPath);
        } else if (isFile(dir, ent) && (ent.name.endsWith(".md") || ent.name.endsWith(".prompt"))) {
          promptSet.add(`/${ent.name.replace(/\.(md|prompt)$/, "")}`);
        }
      }
    } catch {}
  }
  scanPrompts(path.join(agentDir, "prompts"));
  scanPrompts(path.join(cwd, ".pi", "prompts"));
  scanPrompts(path.join(cwd, "prompts"));

  // 5. Themes
  const themeSet = new Set<string>();
  function scanThemes(dir: string) {
    if (!fs.existsSync(dir)) return;
    try {
      for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
        if (ent.name.startsWith(".") || ent.name === "theme-schema.json") continue;
        if (isFile(dir, ent) && ent.name.endsWith(".json")) {
          themeSet.add(ent.name.replace(/\.json$/, ""));
        }
      }
    } catch {}
  }
  scanThemes(path.join(agentDir, "themes"));
  scanThemes(path.join(cwd, ".pi", "themes"));

  return {
    context: Array.from(contextSet),
    extensions: Array.from(extSet).sort(),
    skills: Array.from(skillSet).sort(),
    prompts: Array.from(promptSet).sort(),
    themes: Array.from(themeSet).sort(),
  };
}

export default function (pi: ExtensionAPI) {
  const WIDGET = "pi-splash";

  function clear(ctx: ExtensionContext): void {
    ctx.ui.setWidget(WIDGET, undefined);
  }

  pi.on("session_start", async (_e, ctx) => {
    if (ctx.hasUI) clear(ctx);
  });
}
