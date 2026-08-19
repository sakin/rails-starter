# 10 — Reliability & style tooling

**What to build:** guardrail and style tooling is wired so the repo stays clean automatically — catching N+1s, non-atomic transaction side-effects, and thread-safety issues in the suite, plus linting/formatting and git hooks on commit.

**Blocked by:** 01 — Test harness (RSpec + full test stack), 03 — ViewComponent foundation + contrib + Lookbook

**Status:** resolved

- [x] The non-atomic-IO guard, transactional side-effect handling, and the N+1 guard are invoked by the test run and trip on violations.
- [x] The style/formatting tooling is runnable from a commit hook.
- [x] Frozen-string behavior and typed-config formwork are in place; hooks are installed/installable.
- [x] (Stretch) a mailer preview is surfaced in Lookbook.

## Note (03 realignment) — resolved

Lookbook mount confirmed: keep `Rails.env.development?` gated mount at `/lookbook`.
No `LOOKBOOK_ENABLED` env flag / `/dev/lookbook` path — the dev-only gate is enough
for a starter, stays inert in test, and matches the existing routing-gating spec
(spec/routing/component_previews_spec.rb). The stretch mailer preview is
surfaced as a `Mailer::Component` Lookbook preview under `app/views/components/mailer/`.

## Comments

- Non-atomic-IO / transactional-side-effect guard: added the **Isolator** gem
  (test group, `require: false`; `benchmark` added for its sniffer dep on Ruby 4),
  configured in `spec/support/isolator.rb` (`raise_exceptions = true`, short
  backtrace). Spec `spec/tooling/non_atomic_guard_spec.rb` proves a background
  job enqueued inside a real (`requires_new: true`, materialized) DB transaction
  raises `Isolator::BackgroundJobError`, and the same enqueue outside a
  transaction is fine. Full suite stays green (mail/HTTP under the ambient
  fixture transaction is the tolerated baseline). N+1 guard already wired
  (`n_plus_one_control` + spec/models/n_plus_one_spec.rb).
- Style/formatting commit hook: repo-homed `.githooks/pre-commit` lints staged
  Ruby files with `bin/rubocop`; `bin/setup` installs it idempotently into
  `.git/hooks/pre-commit` (spec spec/tooling/commit_hook_spec.rb). Installed and
  verified on this machine.
- Frozen-string behavior: Ruby 4.0 freezes string literals by default; the
  support/spec files also carry explicit `# frozen_string_literal: true`. Typed
  config uses Rails 8.1's typed Application-level config. Hooks are
  installed/installable.
- Stretch: mailer preview surfaced in Lookbook via
  `app/views/components/mailer/` (component + styles.css + preview) rendering
  `NotificationsMailer#welcome` HTML in an isolated iframe; component spec
  `spec/views/components/mailer_component_spec.rb`. The password-reset mail's
  `password_reset_token` accessor isn't defined on the model (pre-existing, out
  of scope), so only the welcome mail is previewed.
