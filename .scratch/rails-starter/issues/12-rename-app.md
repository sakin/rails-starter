# 12 — bin/rename_to app-name task

**What to build:** renaming the app for a new project is a single command that updates the few places the template's name is baked in, with a documented manual fallback.

**Blocked by:** None — can start immediately.

**Status:** ready-for-agent

- [ ] A single command renames the app module and the named references in the config/debug surfaces (module, deploy service name, PWA manifest, image references).
- [ ] Running it from the untouched template yields a consistently renamed app that still boots and passes specs.
- [ ] The manual fallback checklist is documented, and the repository's default branch is `main`.
