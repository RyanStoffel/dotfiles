---
name: html-communication
description: Create and always publish self-contained HTML writeups of work for Ryan, or read artifacts from postplan.dev URLs. Use for human-readable documents about work, not HTML shipped as part of a product.
metadata:
  harness: [omp, claude, codex]
  platform: [darwin, macos]
  requires: "npx (postplan is run via npx)"
---

# HTML communication

Ryan is the user and owner of this configuration.

## When to use

Use this skill for any request to produce a readable HTML artifact for a human, whether it is called a plan, spec, writeup, findings, summary, report, comparison, diagram, or set of UI mocks. The word "plan" is often absent. What these requests share is a document to read outside the terminal and a link to open it.

Also use this skill whenever Ryan supplies a `postplan.dev` URL to read.

Do not use it for HTML that is part of the product being built, such as app templates, components, or marketing pages. This skill is for documents about work, not shipped UI.

## Read a Postplan URL

When Ryan supplies a `postplan.dev` URL, fetch the uploaded HTML immediately. Do not use web search or a browser to retrieve it.

1. Remove a trailing slash, then append `/raw` unless the URL already ends with `/raw`.
2. Read the raw URL directly. In a shell-only harness, run `curl --fail --silent --show-error --location --max-time 30 --output /tmp/postplan.html <raw-url>`.
3. Read the downloaded HTML as Ryan's artifact and continue the requested task.

A web-search refusal is not evidence that Postplan rejected the request. If retrieval fails, report the actual HTTP status or network error; do not substitute search results.

## Document

Create one self-contained HTML file capped at 512 KB.

- Write it like a spec, not a landing page: dense, scannable, no hero, decorative chrome, marketing voice, or em dashes.
- Default to true black (`#000`), white primary text, and dark gray only for secondary surfaces or accents.
- Make it mobile-readable with a responsive viewport and no fixed-width layout.
- Use semantic HTML, inline CSS, inline SVG, and HTTPS or data-URL images.
- Use an inline classic script only when interactivity materially helps. Keep scripted pages useful without JavaScript; the sandbox blocks storage, fetch, workers, frames, forms, and popups.
- In script-free files, give external links `target="_blank"` and `rel="noopener noreferrer"`. If any script exists, omit `target="_blank"`.

Never include external or module scripts, inline event handlers, `javascript:` URLs, forms, frames, embeds, objects, applets, meta refresh, linked stylesheets, secrets, private URLs, or local filesystem paths.

## UI mocks

When Ryan asks for variants:

- Render real styled variants, not descriptions.
- Label them `A`, `B`, `C`, and so on for easy selection.
- Lay them out for direct comparison.
- Keep one file across iterations so its Postplan URL stays stable.

## Publish

Ryan has given standing permission to upload every artifact created or updated with this skill. Upload is required, including in Auto mode. Do not ask for separate permission or stop at the local file.

1. Write the HTML file locally.
2. Run `npx postplan upload <file-path>`.
3. Report the local path and returned Postplan URL.

Re-upload the same absolute path to update the existing URL. Use `npx postplan upload <file-path> --new` only when Ryan wants a new draft.

If validation fails, fix the markup and retry. If a scripted upload needs authentication, ask Ryan to run `postplan auth login`, then retry without removing the requested interactivity.

Never open a browser or claim the document is hosted before upload succeeds. Do not verify in a browser unless Ryan asks.
