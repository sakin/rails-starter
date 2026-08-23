# CONTEXT — Rails Starter

This is **the starter**: a reference Rails 8.1 application that demonstrates a
layered architecture and a chosen toolchain, published as a template other
projects clone. When a developer renames it and builds on it, it becomes
**their project**.

## Glossary

Terms below are the vocabulary the codebase and docs use. Use these words
rather than drifting to synonyms.

- **starter** — this repository, `rails_starter`. The opinionated, reference
  implementation you clone as a starting point.
- **template** / **new project** — what the starter becomes after
  `bin/rename_to <name>`. Used interchangeably with "their project". Display
  strings and specs intentionally retain "Rails Starter" after a rename, so a
  renamed app still boots and passes the suite.
- **frontend build** — how frontend assets are produced: Vite (via
  `vite_rails`) run by a bundled Bun runtime (`bundlebun`, `bin/bun-vite`).
  No Node/html-pipeline anywhere. See `docs/adr/0001-frontend-build.md`.
- **entrypoint** — a Vite input under `app/frontend/entrypoints/`
  (`application.js`, `application.css`). Entrypoints are wired into the layout
  via `vite_client_tag`/`vite_stylesheet_tag`/`vite_javascript_tag`.
- **component** — a server-rendered view component under
  `app/views/components/<name>/`, with the sidecar set `component.rb`,
  `component.html.erb`, `preview.rb`, and `styles.css`. Built on the
  `view_component` / `view_component-contrib` stack with `dry-initializer`
  typed args, and rendered via a small custom `component "name"` helper
  (relative `component ".nested"` inside a component). "Component" never means a
  JS-framework component; see the divergence note in the README.
- **primitive** — a thin daisyUI wrapper component (layout, nav, flash,
  banner) that stays thin in source and delegates styling to daisyUI utility
  classes. Form primitives are a family of their own (see **forms family**).
- **forms family** — the `Forms::*` form-input view components under
  `app/views/components/forms/`: a dumb `Forms::Form` (`<form>` renderer), the
  `Forms::Field` label/control/error wrapper, typed controls (`Forms::Text`,
  `Textarea`, `Select`, `Checkbox`, `Radio`, `Toggle`), and `Forms::Submit`. 
  Rendered standalone with the `component` helper or composed per-field by the
  `ApplicationFormBuilder` (set as the global `default_form_builder`, so plain
  `form_with` uses it).
- **component arguments** — the common root-level arguments every view component
  accepts: `attrs` (pass-through HTML attributes), plus the promoted `class`,
  `id`, and `data` (deep-merged over the component's own data). Merged by
  `element_attrs` into the root element's attribute hash; a component's style
  variants and defaults come first, so any caller-supplied `class`/`data` overrides
  them. `id` is `attrs[:id]` sugar, not merged.
- **modal** — `Modal::Component`, a daisyUI `<dialog>` that owns dismissal only:
  its co-located `modal` Stimulus controller closes it (`dialog.close()` via
  `click->modal#close` on the backdrop/close button). Opening (`dialog.showModal()`)
  is the caller's job via an external trigger (e.g. the flat `modal-open`
  controller targeting the dialog `id`) — the reference for a component that
  genuinely needs its own behaviour without owning the whole interaction.
- **layout** — `Layout::Component`, the single default layout that owns the
  full HTML document (head, Vite/CSRF/CSP tags, nav + flash region) and yields
  the page body. Wired from `app/views/layouts/application.html.erb`.
- **controller views** — pages under `app/views/controllers/<controller>/`,
  resolved via `append_view_path` in `ApplicationController`. `bin/rails g`
  emits here (generator overrides in `lib/generators/erb/`).
- **mailer views** — mail views under `app/views/mailers/<mailer>_mailer/`
  (e.g. `NotificationsMailer` → `app/views/mailers/notifications_mailer/`),
  resolved via `append_view_path` in `ApplicationMailer`; mailer *layouts* stay
  in `app/views/layouts/`.
- **theme** — the daisyUI light/dark theme chosen by a Stimulus controller
  (`theme_controller.js`) on `data-theme`, persisted in `localStorage`.
- **Solid stack** — the default Rails runtime libraries: `solid_cache`,
  `solid_queue`, `solid_cable`. Each owns a primary-adjacent SQLite database in
  production (`storage/production_*_sqlite3`).
- **Kamal** — the deploy tool (`bin/kamal`, `config/deploy.yml`). Optional:
  its presence or absence never breaks the Docker build.
- **Thruster** — the included HTTP cache/compression server that fronts Puma in
  production.
- **Litestream accessory** — optional, default-off continuous replication of
  the primary SQLite DB to an S3-compatible bucket. See `lib/litestream.rb` and
  `bin/litestream_config`. Never replicates in development.
- **rename** — the one-command rebrand via `bin/rename_to <app-name>` (core in
  `lib/rename_to.rb`), which updates the baked-in name across the application
  module, Kamal deploy, PWA manifest, and Docker image references.

## Glossary usage

Name a domain concept with the terms above. If a concept you need isn't here,
that is a signal: either it's new language the project doesn't use, or there's a
real glossary gap worth a `/domain-modeling` pass.
