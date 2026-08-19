# 12 — bin/rename_to app-name task

**What to build:** renaming the app for a new project is a single command that updates the few places the template's name is baked in, with a documented manual fallback.

**Blocked by:** None — can start immediately.

**Status:** resolved

- [x] A single command renames the app module and the named references in the config/debug surfaces (module, deploy service name, PWA manifest, image references).
- [x] Running it from the untouched template yields a consistently renamed app that still boots and passes specs.
- [x] The manual fallback checklist is documented, and the repository's default branch is `main`.

## Comments

`bin/rename_to <app-name>` (via `bin/rails rename_to[<name>]`) renames the baked-in
name across the four config/debug surfaces: application module
(`config/application.rb`), Kamal deploy (`config/deploy.yml` service/image/volume),
PWA manifest (`app/views/pwa/manifest.json.erb`), and Docker image references.
Transform core is `lib/rename_to.rb` (pure, injectable-file, idempotent; derives
slug/module/display forms from snake/dash/camel input); the rake task in
`lib/tasks/rename_to.rake`; binstub `bin/rename_to`. `--help` prints the manual
fallback checklist (display strings, locale eyebrow, specs, credentials). By
design display strings/specs retain "Rails Starter", so a renamed app still
boots and passes the suite. Verified end-to-end: an untouched tree clone renamed
to `my_app` boots as `MyApp::Application` with no stale `RailsStarter` references
and passes the suite. Default branch is `main`; the CI push trigger was fixed
from `master` → `main`. Coverage: spec/lib/rename_to_spec.rb.
