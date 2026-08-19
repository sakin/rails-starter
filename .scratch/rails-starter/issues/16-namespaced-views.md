# 16 — Namespaced view paths (app/views/controllers + app/views/mailers)

**What to build:** adopt the PRD §3 view layout — controller views under
`app/views/controllers/<controller>/`, mailer views under
`app/views/mailers/<mailer>_mailer/` — wired via `append_view_path`, and make
Rails generators emit into those trees automatically so no stray
`app/views/<name>/` siblings reappear.

**Blocked by:** 13 — README, docs, glossary, and ADRs

**Status:** ready-for-human

- [x] Controller views resolve from `app/views/controllers/<controller>/` via `append_view_path` in `ApplicationController`; existing controller/errors views moved there.
- [x] Mailer views resolve from `app/views/mailers/<mailer>_mailer/` via `append_view_path` in `ApplicationMailer`; existing mail views moved there.
- [x] The `erb:controller`, `erb:scaffold`, `erb:mailer`, and `erb:authentication` generators under `lib/generators/` emit into the namespaced trees.
- [x] README directory conventions, CONTEXT, and the `rails-startup-stack` skill document the two namespaced roots (and that the PRD's `views/controllers` / `views/mailers` plan is now adopted).

## Implementation note

The generator overrides (checked in under `lib/generators/erb/` and
`lib/generators/rails/`) are loaded by a small `RailsStartupStack::ViewOverrides`
Railtie (`lib/rails_startup_stack/view_overrides.rb`, required from
`config/application.rb`). Without it, namespaced generators like `erb:controller`
resolve Railties' copy first and the overrides never load. It is a `Railtie`,
not an `Engine`, so no route-mounting behavior is added.
