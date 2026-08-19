# 08 — bin/setup + bin/dev

**What to build:** a fresh clone gets running with one command. Setup installs gems and prepares the database; the dev command boots the web server and the asset watcher together, staying hot-reloading.

**Blocked by:** 02 — Frontend swap: Vite + bundlebun + Tailwind v4 + daisyUI 5

**Status:** resolved

- [x] From a fresh clone, a bundle install is the only prerequisite before setup succeeds (gems installed, DB prepared).
- [x] The dev command starts the web server and the frontend watcher together and keeps them hot-reloading.
- [x] No manual JS runtime install; Bun comes from the bundle.

## Comments

`bin/dev` now runs both processes via Foreman (`foreman start -f Procfile.dev`).
`Procfile.dev` declares `web: bin/rails server` and `vite: bin/bun-vite dev`, so the
Vite watcher runs under the bundle's Bun (`bin/bun-vite`; `config/vite.json` already
sets `viteBinPath` to it) — no Node/npm/yarn. `foreman` added to the development
group. `bin/setup` untouched (bundle check/install → db:prepare, then `exec bin/dev`
unless `--skip-server`). Smoke-tested: both Puma (5000) and Vite (3036 v8.2.1)
come up together and hot-reload. Coverage: spec/tooling/dev_commands_spec.rb.
