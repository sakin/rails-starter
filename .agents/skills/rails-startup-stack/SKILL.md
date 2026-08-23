---
name: rails-startup-stack
description: Bootstrap and navigate this Rails starter's specific stack. Use when a new project is being created from the starter, when renaming/bootstrapping a clone, or when deciding where a piece of Rails code or UI belongs in THIS stack — its directory conventions, view components, the frontend escalation ladder, or the gem/tooling roles. Assumes layered-rails for the architectural "why"; this skill covers the "where/how" for this stack.
---

# Rails Startup Stack

The `layered-rails` skill owns the architectural *why* — the four layers, the
unidirectional-dependency rule, the specification test, and the pattern catalog
(form objects, policy objects, view components, …). **This skill does not
re-argue any of that.** For any layering decision, consult `layered-rails` first;
use these references to answer *where it lives and how it is wired in this
starter*.

This stack is the reference implementation of that layered pattern: models hold
domain logic, controllers stay thin, and purpose-built layers (`app/forms`,
`app/policies`, `app/notifications`) replace the `app/services` catch-all.

## When to reach for this skill

- **Booting/targeting a new project from the template** — run the
  [bootstrap-project workflow](workflows/bootstrap-project.md): `bin/rename_to`,
  credentials, deploy config, CI, and a green suite. It is the executable form of
  the README's "Template-use checklist".
- **Placing Rails code** — a form, policy, notification, model, controller, or
  view component is coming in; decide which directory/layer it belongs to with
  [directory-conventions.md](references/directory-conventions.md), mapped onto
  layered-rails' four layers.
- **Building or extending UI** — the component sidecar set, the `component`
  helper, the generator, `dry-initializer`, the DB-query guard, and Lookbook are
  all in [view-components.md](references/view-components.md).
- **Choosing frontend tooling** — decide where on the escalation ladder a page
  belongs (plain component → Stimulus → new entrypoint → Turbo Mount/Inertia)
  with [frontend-ladder.md](references/frontend-ladder.md).
- **Choosing a gem or knowing what a gem is for** — see
  [gems.md](references/gems.md) for each installed gem's role and the
  deliberately-optional next-tier additions.
- **Operating the local dev environment** (locating/inspecting/adding a gem,
  the `tmp/` tree, the local toolchain) — see the `local-environment` skill;
  this skill is *placement*, that one is *operations*.

For the *why* behind any of these — layered refactors, extracting a service or
policy, running the specification test — reach for `layered-rails`. This skill
only narrows those principles to this stack's concrete layout and conventions.
