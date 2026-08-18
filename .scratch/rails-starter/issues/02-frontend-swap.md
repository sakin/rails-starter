# 02 — Frontend swap: Vite + bundlebun + Tailwind v4 + daisyUI 5

**What to build:** the frontend is built by Vite using a bundled Bun runtime — no Node anywhere (dev, CI, or Docker) — and Tailwind v4 with daisyUI 5 styles every page, hot-reloading as assets change.

**Blocked by:** None — can start immediately.

**Status:** resolved

- [x] A fresh checkout gets the JS runtime purely from the bundle (Bun, version-pinned in the lockfile); no Node/npm/Yarn install step exists anywhere.
- [x] The old JS pipeline is gone; entrypoints build through Vite.
- [x] A page renders with Tailwind + daisyUI styling applied (a daisyUI button/alert is visibly themed).
- [x] Assets dev-rebuild on change; the CSS entrypoint loads Tailwind + daisyUI at a pinned, compatible version set (side-step the `@plugin` resolution quirk).

## Comments

Frontend is built by Vite (via `vite_rails`) run by a Bun runtime bundled by `bundlebun` (`bin/bun`, pinned to Bun 1.3.14 in the lockfile; `bin/bun-vite` is the configured runner in `config/vite.json`). `importmap-rails` and the `app/javascript/` pipeline were removed; the layout now uses `vite_client_tag`/`vite_stylesheet_tag`/`vite_javascript_tag`, with entrypoints under `app/frontend/`. CSS loads Tailwind v4 + daisyUI 5 pinned in `package.json`/`bun.lock`; daisyUI is attached via `@plugin "daisyui/index.js"` to side-step the JS-plugin-resolution quirk. `pages#home` is the themed root page; `spec/system/frontend_styles_spec.rb` proves the compiled stylesheet actually carries the `.alert`/`.btn-primary` rules. Dev rebuild (auto-build + `vite_client_tag`) is configured at the Vite layer; `bin/setup`/`bin/dev` and CI/Docker wiring wait on tickets 08/09.
