# Directory conventions

How this starter is laid out, mapped onto layered-rails' four layers
(Presentation → Application → Domain → Infrastructure). Use this when deciding
where a piece of Rails code belongs. For the *rules* behind the mapping (no
reverse dependencies, the specification test), defer to `layered-rails`.

The governing invariant: **no `app/services`**. Purpose-built layers replace a
services catch-all. Models hold domain logic; controllers stay thin.

## Quick map

| Path | Layer | Responsibility |
|------|-------|----------------|
| `app/models/` | Domain | Business entities, rules, invariants |
| `app/controllers/` (+ `concerns/`) | Presentation | HTTP concerns only — thin |
| `app/forms/` | Presentation | Complex UI forms, multi-model validation |
| `app/policies/` | Application | Authorization decisions |
| `app/notifications/` | Application | Unified notification (email/Slack/SMS channels) |
| `app/views/controllers/<controller>/` | Presentation | Controller views, namespaced (PRD §3) |
| `app/views/mailers/<mailer>_mailer/` | Presentation | Mailer views, namespaced (PRD §3) |
| `app/views/components/` | Presentation | Server-rendered view components |
| `app/views/layouts/` | Presentation | Layouts (incl. delegated `Layout::Component`) |
| `app/mailers/` | Presentation | Email composition (mailer classes; their views live in `views/mailers/`) |
| `app/jobs/` | Application | Coordinate workflow; models execute |
| `app/channels/` | Presentation | WebSocket connections (Solid Cable) |
| `app/frontend/` | Presentation | Vite entrypoints + Stimulus controllers; reserved for JS |
| `lib/` | Infrastructure/domain-support | Pure, testable app logic (rename, litestream, generators) |

## The layered layers in detail

### Domain — `app/models/`
Business entities, rules, and invariants. Namespaced domain behaviour should
live here (or under the model), not in a services folder. Query objects and
value objects, when needed, sit here too per layered-rails.

### Presentation — `app/controllers/`, `app/views/`, `app/forms/`
Controllers handle HTTP concerns only — parse, authorize, delegate, redirect.
Views render. `app/forms/` holds UI-driven form objects (e.g.
`RegistrationForm`) that validate and persist for a specific screen.

**Where views live:** controller views sit under `app/views/controllers/<controller>/`
and mailer views under `app/views/mailers/<mailer>_mailer/` (PRD §3), rather than at
Rails' default `app/views/<controller>/`/`app/views/<mailer>_mailer/`. Resolved
by `append_view_path` in `ApplicationController`/`ApplicationMailer`; generators
emit into these trees via `lib/generators/erb/` and `lib/generators/rails/`
overrides, so no stray default-path view tree is reintroduced. Put a new
controller view under `app/views/controllers/…`, never `app/views/<controller>/`.

### Application — `app/policies/`, `app/notifications/`, `app/jobs/`
- `app/policies/` — authorization. `ApplicationPolicy` defines
  `user:`/`record:` and a `NotAuthorizedError`; concrete policies expose
  `#show?`-style predicates. `ApplicationController#authorize(record, with:)`
  dispatches to the `#{action_name}?` predicate and renders a 403 on
  `NotAuthorizedError`.
- `app/notifications/` — a single entry point
  (`ApplicationNotification.deliver(...)`) that routes to channels (email is the
  one shipped). Add channels by overriding a notification's `#deliver`.
- `app/jobs/` — coordinate workflow; the domain model executes. Keep them thin.

## Frontend — `app/frontend/`
Reserved by design for JS-side concerns: Vite `entrypoints/` and Stimulus
`controllers/` (auto-registered from the filename). Server-rendered UI lives in
view components; a JS framework (Turbo Mount / Inertia) mounts on the same Vite
build without changing it — see [frontend-ladder.md](frontend-ladder.md).

## Non-`app/` layout

- `lib/` — pure, testable application logic: `lib/rename_to.rb` (the rename
  core), `lib/litestream.rb`, and the project-owned generators under
  `lib/generators/` (`view_component`, plus the `erb/` + `rails/` overrides that
  keep generated controller/mailer views in the namespaced trees).
- `bin/` — key binstubs include `bin/setup`, `bin/dev`, `bin/rename_to`,
  `bin/rspec`, `bin/ci`, `bin/litestream_config`, `bin/docker-entrypoint`;
  the full list is whatever `bin/rails` exposes plus the checked-in scripts under
  `bin/`.
- `config/vite.json` — Vite runner and per-environment ports/output dirs.
- `app/views/layouts/application.html.erb` — delegates to the shared
  `Layout::Component` (owns head, Vite/CSRF/CSP tags, nav, flash).

Full prose lives in `README.md` (§ Directory conventions). This file is the
mapping onto layered-rails for in-work placement decisions.
