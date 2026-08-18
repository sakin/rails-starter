# 04 — Auth core

**What to build:** people can sign in, sign out, and reset a forgotten password. Sessions are stored server-side (so they can be revoked), and unauthenticated visitors are steered to sign-in. This is the starter's reference implementation of the layered architecture, not a product feature.

**Blocked by:** 01 — Test harness (RSpec + full test stack)

**Status:** resolved

- [x] Sign in/out works with database-backed sessions; reset sends and consumes a token.
- [x] Guests are redirected to sign-in for protected pages; signed-in people are recognized.
- [x] The flow is expressed as linked model + controller-concern pieces consistent with the architecture, with specs green.
- [x] The chosen generator was run, then its output carved to fit the layering (no catch-all services entry).

## Answer

Ran Rails 8.1's `rails generate authentication`, then carved to the layered pattern (commit `98d656b`). Server-side, database-backed sessions (revocable) via `User`/`Session`/`Current` models + the `Authentication` controller concern wired into `ApplicationController`; sign in/out through `SessionsController` (`resource :session`); password reset through `PasswordsController` + `PasswordsMailer` (`resources :passwords, param: :token`). The reset token uses `has_secure_password`'s built-in `reset_token: true` (native `password_reset_token`/`find_by_password_reset_token!`, a signed expiring verifier invalidated on password change) — no manual token column. A minimal `AccountController#show` is the protected reference surface proving guest redirect + signed-in recognition; `pages#home` opts out via `allow_unauthenticated_access`. Visible sign-though (nav, sign-out control, flash layout) is deferred to 06. Added `bcrypt`, `CreateUsers`/`CreateSessions` migrations, `:user`/`:session` factories, model + mailer + request specs (54 examples green), and switched `config/ci.rb` to `bin/rspec`.
