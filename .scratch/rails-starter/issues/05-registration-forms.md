# 05 — Registration via the forms layer

**What to build:** new people can create an account and are signed in immediately, through a purpose-built form object living in the app's dedicated UI-forms layer rather than by mutating a model directly from the controller.

**Blocked by:** 04 — Auth core

**Status:** resolved

- [x] A sign-up page collects email + password, creates an account, and signs the person in on success.
- [x] Validation failures re-render the form with errors and no state drift.
- [x] Sign-up logic is expressed as a purpose-built form object (the layer's reference usage); specs cover success and failure.

## Answer

Introduced the UI-forms layer with `app/forms/RegistrationForm` (ActiveModel::Model +
Attributes; builds a `User`, mirrors its errors onto the form, `#save` persists, `#user`
exposes the built user for immediate sign-in). `RegistrationsController` (`resource
:registration, only: %i[new create]`) is `allow_unauthenticated_access`, calls `@form.save`,
signs the person in via `start_new_session_for(@form.user)` on success (redirect to root with
notice), and re-renders `new` with `422 :unprocessable_content` on failure (errors shown, email
retained, no partial record). Minimal sign-up view at
`app/views/registrations/new.html.erb` (layout/primitive polish deferred to 06). Added 13
examples: `spec/forms/registration_form_spec.rb` (success/normalization/blank/duplicate,
no-state-drift) and `spec/requests/registrations_spec.rb` (guest reachable, creates+signs in,
error re-render). Rubocop clean; full suite 67 examples green.
