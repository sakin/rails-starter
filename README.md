# Rails Starter

A reference Rails 8.1 application that demonstrates a layered architecture and
a chosen toolchain. It ships as a **template**: clone it, run
`bin/rename_to your_name`, and build on it. See `CONTEXT.md` for the shared
vocabulary (starter / template / component / Solid stack / …).

## Quick start

```sh
bin/setup          # bundle install, db:prepare, install pre-commit hook
bin/dev            # Rails server + Vite watcher together (Foreman), hot-reloading
```

The frontend JS runtime is **Bun**, shipped in the RubyGems bundle by
`bundlebun` (`bin/bun`, `bin/bun-vite`) — **no Node/npm/Yarn install step
exists**; the RubyGems install pulls everything Vite needs. In development
`bin/bun-vite dev` builds and watches automatically (see `config/vite.json`),
and `assets:precompile` compiles through that same bundled Bun at deploy time.

Run the suite with `bin/rspec` (alias `bin/ci` for the CI job). `bin/rubocop`
lints; `bin/brakeman` and `bin/bundler-audit` scan for vulnerabilities.

## Directory conventions

- `app/views/components/<name>/` — server-rendered **components**, each with the
  sidecar set `component.rb` (Dry::Initializer args), `component.html.erb`,
  `preview.rb` (Lookbook), and `styles.css`. Render with
  `component "name"`, and relatively as `component ".nested"` inside another
  component. Component styles are bundled by an entrypoint glob over
  `**/styles.css`, so they are automatically class-for-scoped by `class_for`.
  Generate one with `bin/rails generate view_component NAME [attrs]`.

  These choices diverge deliberately from the `view_component-contrib` gem's
  default of `app/frontend/components`: the starter reserves `app/frontend/`
  for JS-framework components (PRD §3), so server-rendered components live under
  `app/views/components/` and use a custom `component` helper +
  `dry-initializer` args + relative rendering rather than the gem's defaults.
- `app/views/layouts/application.html.erb` — delegates to the shared
  `Layout::Component`, which owns the full HTML document, Vite/CSRF/CSP tags,
  nav, and flash region. Auth pages inherit it automatically.
- `app/views/controllers/<controller>/` — controller views, namespaced under one
  root (PRD §3), resolved via `append_view_path` in
  `ApplicationController`. `bin/rails g` (controller/scaffold/authentication)
  emit here via the generator overrides in `lib/generators/erb/…`, so no sibling
  `app/views/<controller>/` tree reappears.
- `app/views/mailers/<mailer>_mailer/` — mailer views, namespaced under one root
  (PRD §3), resolved via `append_view_path` in `ApplicationMailer` (e.g.
  `NotificationsMailer` → `app/views/mailers/notifications_mailer/`).
  `bin/rails g` (mailer/authentication) emit here via
  `lib/generators/erb/mailer/…`; mailer *layouts* still live in
  `app/views/layouts/`.
- `app/frontend/` — Vite entrypoints (`entrypoints/`) and Stimulus controllers
  (`controllers/`). Reserved by design for JS-side concerns; server-rendered
  UI lives in components (see `docs/adr/0001-frontend-build.md`).
- `lib/` — pure, testable application logic: `lib/rename_to.rb`,
  `lib/litestream.rb`, and the project-owned generators under
  `lib/generators/` (`view_component`, plus the `erb/` and `rails/` overrides
  that keep generated views in the namespaced trees).
- `bin/` — binstubs: `bin/dev`, `bin/setup`, `bin/rename_to`, `bin/rspec`,
  `bin/ci`, `bin/litestream_config`, `bin/docker-entrypoint`.
- `config/vite.json` — Vite runner and per-environment ports/output dirs.
- `.scratch/<feature-slug>/issues/` — the issue tracker (see
  `docs/agents/issue-tracker.md`).

## Frontend escalation ladder

Start where the template leaves you and climb only as needed:

1. **Add a component** — `bin/rails generate view_component name attrs`, then
   render it from a view. No new tooling.
2. **Add a Stimulus controller** — drop `app/frontend/controllers/foo_controller.js`;
   it is registered automatically (identifier derives from the filename), and
   recompile via the Vite watcher.
3. **Style / theme** — edit `app/frontend/entrypoints/application.css` (Tailwind
   v4 + daisyUI 5). Switch themes via the nav toggle (Stimulus
   `theme_controller.js`, persisted to `localStorage`).
4. **Add an entrypoint** — list a new file under `app/frontend/entrypoints/`
   and load it with `vite_javascript_tag` / `vite_stylesheet_tag` in the
   layout.
5. **Adopt a JS framework** — mount it on the same Vite build (same entrypoints,
   same `/components` model). `app/frontend/` is deliberately reserved for this;
   see `docs/adr/0001-frontend-build.md`.

Each rung keeps the previous ones working; nothing above changes the build or
Docker.

## Swap SQLite for Postgres

The template runs SQLite (four production DBs: one primary + the Solid cache/queue/
cable). To move to Postgres:

1. `gem "pg"` in the Gemfile (drop `sqlite3`), `bundle install`.
2. Rewrite `config/database.yml` adapters and hosts for PG.
3. Replace the `storage/*` path for your provider; the Solid databases can stay
   on SQLite or migrate too (see the Solid docs for `DATABASE_URL` per role).
4. Run `bin/rails db:prepare`, then the suite: `bin/rspec`.
5. Note the Litestream accessory (below) only replicates SQLite; on Postgres use
   the provider's native backup instead.

## Next-tier gems

The starter is deliberately lean. When a project outgrows it, commonly-proven
additions (each a sharp, optional upgrade rather than a rewrite):

- **Jobs**: `solid_queue` ships as a dependable default. Climb to
  **Sidekiq + Redis** when you need higher throughput, retry/backoff control,
  or a hosted cursor.
- **Cache/action cable**: `solid_cache` / `solid_cable` are file-backed defaults.
  Migrate their backends to **Redis** when the production box or
  multi-instance scale demands it.
- **Search**: add a purpose-built engine (e.g. `pg_search` or a hosted provider)
  rather than hand-rolling `LIKE` queries.
- **Observability**: wire tracing/error tracking (e.g. Sentry/Otel) and the
  `stackprof` profiler (already a dev dependency) for dashboards.
- **Auth hardening**: the built-in auth (see `docs/adr/0002-authentication.md`)
  is the reference; swap to Devise/OmniAuth only for feature parity you truly
  need (additive multi-provider sign-in, locks, etc.).
- **Storage**: `image_processing` + Active Storage cover attachments; add a
  cloud/CDN only when you actually serve large media.

This list is opinionated and optional — nothing here is required.

## Template-use checklist

Rebranding the clone for a new project:

1. `bin/rename_to your-app-name` (or `bin/rails rename_to[your-app-name]`).
   Renames the application module, Kamal deploy service/image/volume, PWA
   manifest, and Docker image references. `bin/rename_to --help` prints the
   manual fallback for the display strings and locale eyebrow.
2. `bin/rails credentials:edit` to set your own secrets (the template's
   `config/master.key` is for development only — never commit it).
3. Update `config/deploy.yml` (server hosts) and `.github` CI if you deploy.
4. Confirm with `bin/setup` + `bin/rspec`.
5. Default branch is **`main`**; keep sync/PR bases on it.

## Deployment

The app builds into a production Docker image with the official Ruby base and
**no Node step**. Two optional, independent accessories:

- **Kamal** — `config/deploy.yml` keeps the stock deploy config, but it is
  *optional*: its presence or absence never breaks the Docker build. Deploy
  with `bin/kamal deploy`; skip it and run the image directly (`:80` fronted by
  Thruster → Puma on :3000) if you prefer another path.
- **Litestream** — optional, **off by default** continuous backup of the primary
  SQLite database to S3. Supply the `LITESTREAM_BUCKET` / `_ACCESS_KEY_ID` /
  `_SECRET_ACCESS_KEY` / `_REGION` (and optional `_ENDPOINT`) env vars to the
  production container to enable it; without them the app runs unchanged and
  replicates nothing. Local development and the test suite never replicate.
  Config is rendered at container start by `bin/litestream_config`; see
  `lib/litestream.rb`. Only the primary app DB is backed up, never the Solid
  databases.

## Documentation

- `CONTEXT.md` — the shared glossary (starter/template/component/Solid stack…).
- `docs/adr/` — architecture decisions (frontend build; authentication).
- `docs/agents/` — how the engineering agent skills operate on this repo.
- `.scratch/` — the issue tracker and specs.
