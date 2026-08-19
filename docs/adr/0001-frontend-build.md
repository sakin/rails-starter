# ADR-0001 — Frontend build: Vite + bundled Bun + Tailwind v4 + daisyUI 5

## Status

Accepted.

## Context

The starter ships a styled, hot-reloading frontend without heavyweight tooling.
We needed a build that:

- works with **no Node anywhere** (development, CI, and the production Docker
  image use a single pinned JS runtime),
- styles every page consistently, with a themable look,
- hot-reloads in development,
- keeps the door open for real JavaScript-framework components later, without
  adopting one now.

The stock Rails 8.1 pipeline (`importmap-rails` + `app/javascript/`) serves
pre-bundled assets with no build step, but offers neither on-the-fly styling
with Tailwind v4 / daisyUI nor a clean path toward a component framework.

## Decision

Replace importmaps and the `app/javascript/` pipeline with **Vite** (via
`vite_rails`), run by a **bundled Bun** runtime instead of Node:

- Bun is version-pinned and fetched purely from the bundle (`bundlebun`, see
  `bin/bun`), so there is **no Node/npm/Yarn install step anywhere**.
- `bin/bun-vite` (configured as `viteBinPath` in `config/vite.json`) is the Vite
  runner; entrypoints live under `app/frontend/`.
- The layout uses `vite_client_tag` / `vite_stylesheet_tag` /
  `vite_javascript_tag`.
- **Tailwind v4** + **daisyUI 5** (pinned in `package.json` / `bun.lock`) style
  every page; daisyUI is attached via `@plugin "daisyui/index.js"` to side-step
  the JS-plugin-resolution quirk.
- Development assets auto-build and hot-reload.

`app/frontend/` is reserved for JS-framework-style components (see PRD §3); the
starter's server-rendered view components live under `app/views/components/`
(see `CONTEXT.md`).

## Consequences

- A fresh checkout needs only Bun from the bundle: `bin/setup` then `bin/dev`
  boot the web server and Vite watcher together (`bin/dev` via Foreman; see
  `Procfile.dev`).
- The production Docker image builds `assets:precompile` through the bundle's
  Bun with **no Node install** (multi-stage build, verified in ticket 09).
- Testing the compiled output requires the test runner to compile assets;
  `spec/system/frontend_styles_spec.rb` asserts the compiled stylesheet carries
  the daisyUI `.alert` / `.btn-primary` rules.
- Escalation path: add entrypoints and Stimulus controllers as needed, and
  reach for a JS component framework later by mounting it on the same Vite
  build rather than swapping pipelines.
