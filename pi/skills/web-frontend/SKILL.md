---
name: web-frontend
description: Build, run, lint, typecheck, and test Next.js / React / TypeScript web projects. Use for JS/TS web apps — detect the package manager first.
---
# Web frontend (Next.js / React / TypeScript)

## Detect the package manager (project root)
`pnpm-lock.yaml` → pnpm · `bun.lockb` → bun · `yarn.lock` → yarn · `package-lock.json` → npm.
Use that manager for everything below (examples use pnpm).

## Commands
- Install: `pnpm install`
- Dev server: `pnpm dev`
- Build: `pnpm build`
- Lint: `pnpm lint` (or `pnpm exec eslint .`)
- Typecheck: `pnpm exec tsc --noEmit`
- Test: `pnpm test` — confirm the runner in `package.json` (vitest/jest/playwright)
- Format: project-local prettier `pnpm exec prettier --write <files>` if configured

## Notes
- Read `package.json` `scripts` before guessing a command.
- Next.js: check `app/` (app router) vs `pages/` (pages router).
