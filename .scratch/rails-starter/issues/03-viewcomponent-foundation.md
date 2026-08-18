# 03 — ViewComponent foundation + contrib + Lookbook

**What to build:** the app can author components under a sidecar convention, generate new ones, render them from views, and preview them in an environment-gated Lookbook. Components get typed initializer args and fail loudly if they fire database queries.

**Blocked by:** 02 — Frontend swap: Vite + bundlebun + Tailwind v4 + daisyUI 5

**Status:** ready-for-agent

- [ ] Running the component generator yields a sidecar component, its preview, and its styles.
- [ ] A trivial component renders from a view via the component helper, with component-scoped i18n lookups.
- [ ] Lookbook previews are reachable only when enabled; a component running a DB query raises unless explicitly allowed.
- [ ] Typed initializer args and relative/nested component rendering work.
- [ ] The view-component extension gem is adopted per its conventions (base classes, custom generator, paths).
