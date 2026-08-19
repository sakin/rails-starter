# ADR-0002 — Authentication: layered, database-backed sessions carved from the Rails generator

## Status

Accepted.

## Context

The starter is the reference implementation of a layered architecture, not a
standalone product feature. We needed sign-in, sign-out, and password reset as
a demonstration of how a cross-cutting concern is expressed with that
architecture — revocable sessions, and guests steered to sign-in.

## Decision

Run Rails 8.1's `rails generate authentication`, then **carve its output to the
layered pattern** (no catch-all "services" entry):

- **Database-backed, revocable sessions** via a `Session` model, exposed
  through `Current` and the `Authentication` controller concern wired into
  `ApplicationController`.
- Sign in/out through `SessionsController` (`resource :session`); password
  reset through `PasswordsController` + `PasswordsMailer`
  (`resources :passwords, param: :token`).
- The reset token uses `has_secure_password`'s built-in
  `password_reset_token: true` (a signed, expiring verifier invalidated on
  password change) — **no manual token column**.
- A minimal `AccountController#show` is the protected reference surface proving
  guest redirect + signed-in recognition; `pages#home` opts out via
  `allow_unauthenticated_access`.
- `bcrypt` for password hashing.
- The `Authentication` concern loads the session on every request and
  eager-loads the user so the guarded layout/nav can read identity
  (`Current.session` / `Current.user`) without firing queries during view
  render (which `DbQueryGuard` would otherwise reject).

## Consequences

- Sessions are revocable by deleting the `Session` row (server-side, not
  cookie-stored identity).
- Auth is one more example of the layered pattern — models, a controller
  concern, controllers, and mailers — rather than a bespoke framework bolted on.
- `CreateUsers` / `CreateSessions` migrations and `:user` / `:session`
  factories ship with the starter, so a new project inherits the reference
  surface and its specs (model + mailer + request; 54 examples on landing).
- The auth pages render through the shared `Layout::Component` (see ticket 06).
