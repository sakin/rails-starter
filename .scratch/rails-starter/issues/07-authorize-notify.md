# 07 — Authorize & notify on auth

**What to build:** the auth reference extends through two more architecture layers: an example policy gates a protected action, and signing up triggers a welcome notification sent through the app's unified notification layer.

**Blocked by:** 05 — Registration via the forms layer

**Status:** resolved

- [x] A protected action is authorized by an example policy (allowed/denied visibly branch).
- [x] Sign-up triggers a welcome notification through the unified delivery layer (email by default).
- [x] Both behaviors have specs; the policy and notification pieces are wired as their own layers, not a services catch-all.

## Answer

Added two more self-contained architecture layers (hand-rolled, no new gems — matching the starter's lean ethos and the "not a services catch-all" constraint).

**Policy layer** (`app/policies/`): `ApplicationPolicy` (holds `user:`/`record:`, defines `NotAuthorizedError`) + `AccountPolicy#show?` (`record == user`). `ApplicationController` gains a thin `authorize(record, with:)` hook dispatching to the `#{action_name}?` predicate and a `rescue_from` that renders `app/views/errors/forbidden.html.erb` as 403. `AccountController#show` (`GET /account`) is the protected reference action: it authorizes the requested account and fails 403 when the viewer isn't the owner (`/account?user_id=<someone else>`), so allowed and denied branches are both observable, and guests are still steered to sign-in first.

**Notification layer** (`app/notifications/`): `ApplicationNotification.deliver(...)` is the single entry point; `WelcomeNotification < ApplicationNotification` delivers through its email channel (currently the only one), calling `NotificationsMailer#welcome` via `deliver_later`. Additional channels, if ever needed, slot into the concrete notification's `#deliver` — callers stay on `.deliver`. `RegistrationForm#save` now fires `WelcomeNotification.deliver(user:)` after persisting (and only then — invalid saves queue nothing).

Specs (+13, suite 81 → 94 green; rubocop omakase clean): `spec/policies/account_policy_spec.rb`, `spec/requests/account_spec.rb` (200 allowed / 403 denied / guest redirect), `spec/notifications/welcome_notification_spec.rb`, `spec/mailers/notifications_mailer_spec.rb`, plus delivery assertions in `spec/forms/registration_form_spec.rb` and `spec/requests/registrations_spec.rb` (welcome mail enqueued on sign-up, none on failure).
