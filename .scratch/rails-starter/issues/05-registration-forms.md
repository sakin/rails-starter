# 05 — Registration via the forms layer

**What to build:** new people can create an account and are signed in immediately, through a purpose-built form object living in the app's dedicated UI-forms layer rather than by mutating a model directly from the controller.

**Blocked by:** 04 — Auth core

**Status:** ready-for-agent

- [ ] A sign-up page collects email + password, creates an account, and signs the person in on success.
- [ ] Validation failures re-render the form with errors and no state drift.
- [ ] Sign-up logic is expressed as a purpose-built form object (the layer's reference usage); specs cover success and failure.
