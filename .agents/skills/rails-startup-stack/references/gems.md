# Gem and tooling roles

What each installed gem is *for* in this stack, so an agent picks the right tool
instead of re-solving a solved problem. This maps roughly onto layered-rails'
layered gem catalog (`references/gems/`) but reflects what the starter actually
ships. The README's "Next-tier gems" is the deliberately-optional growth list.

## Installed, by concern

| Concern | Gem | Role |
|---------|-----|------|
| Core Rails | `rails` (8.1), `puma`, `bootsnap`, `propshaft` | Stock runtime, serving, boot caching, asset pipeline (image logic kept out of the custom Vite build). |
| Solid stack | `solid_cache`, `solid_queue`, `solid_cable` | Rails 8's default primary-adjacent SQLite-backed cache/queue/cable — no Redis. |
| Database | `sqlite3`, `bcrypt`, `image_processing` | SQLite; password hashing (auth); image variants. |
| Frontend build | `vite_rails`, `bundlebun` | Vite build driven by a Bun runtime shipped in the gem bundle — no Node anywhere. |
| Hotwire | `turbo-rails`, `stimulus-rails` | Default page-rendering path + the modest JS framework (see frontend ladder). `jbuilder` for JSON. |
| View layer | `view_component`, `view_component-contrib`, `dry-initializer` | Server-rendered components (see [view-components.md](view-components.md)). |
| Previews | `lookbook` | Dev-only component/mailer preview environment mounted at `/lookbook`. |
| Auth | (hand-rolled layered auth, `bcrypt` only) | Database-backed sessions carved to the layered pattern — see `docs/adr/0002-authentication.md`. No Devise. |
| Deploy | `kamal`, `thruster` | Both optional; their presence or absence never breaks the Docker build. |
| Dev | `foreman`, `web-console`, `debug` | `bin/dev` runs Rails + Vite together; console/debug support. |

## Testing / quality

| Tool | Role |
|------|------|
| `rspec-rails` | Test framework (`bin/rspec`, `bin/ci`). |
| `capybara` + `cuprite` | System tests; headless Chromium via CDP/Ferrum, no driver binary to match, no Node. |
| `factory_bot_rails`, `faker` | Factories and seed data. |
| `webmock` | Disallow live outbound HTTP in the suite. |
| `n_plus_one_control` | N+1 matcher. |
| `stackprof` | Suite profiling. |
| `isolator` | Raises on non-atomic IO / transactional-side-effect guards (jobs, mail, HTTP, cache in a transaction). |
| `rubocop-rails-omakase` | Lint house style (`bin/rubocop`). |
| `brakeman` | Security scan (`bin/brakeman`). |
| `bundler-audit` | Gem vulnerability audit (`bin/bundler-audit`). |

## Deliberately optional next tier (README)

Not installed in v1; graded upgrades, each sharp and optional rather than a
rewrite:

- **Jobs**: `solid_queue` default → **Sidekiq + Redis** where throughput matters.
- **Cache/cable**: **Redis** backends at scale/multi-instance.
- **Search**: a purpose-built engine (e.g. `pg_search`) over hand-rolled `LIKE`.
- **Observability**: Sentry/Otel + `stackprof`.
- **Auth hardening**: Devise/OmniAuth only for additive feature parity
  (multi-provider sign-in, locks) — the built-in auth is the reference.
- **Storage**: cloud/CDN only when actually serving large media.
- **Frontend escalation**: Turbo Mount / Inertia — see
  [frontend-ladder.md](frontend-ladder.md).
- **Database**: Postgres swap — see README § "Swap SQLite for Postgres".

## Optional runtime accessories

- **Kamal** — `config/deploy.yml`; deploy with `bin/kamal deploy`, or run the
  image directly (Thruster → Puma).
- **Litestream** — continuous backup of the primary SQLite DB to S3, **off by
  default**. Enabled by supplying `LITESTREAM_*` env vars; rendered at container
  start by `bin/litestream_config`; only the primary app DB, never the Solid DBs.
  See `lib/litestream.rb`.
