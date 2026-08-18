# 03 — ViewComponent foundation + contrib + Lookbook

**What to build:** the app can author components under a sidecar convention, generate new ones, render them from views, and preview them in an environment-gated Lookbook. Components get typed initializer args and fail loudly if they fire database queries.

**Blocked by:** 02 — Frontend swap: Vite + bundlebun + Tailwind v4 + daisyUI 5

**Status:** resolved

- [x] Running the component generator yields a sidecar component, its preview, and its styles.
- [x] A trivial component renders from a view via the component helper, with component-scoped i18n lookups.
- [x] Lookbook previews are reachable only when enabled; a component running a DB query raises unless explicitly allowed.
- [x] Typed initializer args and relative/nested component rendering work.
- [x] The view-component extension gem is adopted per its conventions (base classes, custom generator, paths).

## Answer

Adopted `view_component` 4 + `view_component-contrib` (base classes, sidecarable previews, component-scoped i18n) + `lookbook` (dev-only).

- Sidecar convention under `app/frontend/components/<name>/` with `component.rb`, `component.html.erb`, `preview.rb`, `index.css`, `index.js`.
- Base classes `ApplicationViewComponent` (includes `DbQueryGuard`) and `ApplicationViewComponentPreview`.
- Custom generator `rails generate view_component NAME` (`lib/generators/view_component`).
- Component-scoped i18n via contrib (`t(".key")` → `en.view_components.<scope>`); demo `Banner` + nested `Badge`.
- `DbQueryGuard` raises `DbQueryGuard::UncheckedQueryError` when a component fires SQL during render unless it calls `.allow_db_queries!` (upstream `raise_on_db_queries` was removed in ViewComponent 4).
- Lookbook mounted only when `Rails.env.development?`; frontend aggregates sidecar `index.css` via Vite glob.

Specs at `spec/components`, `spec/generators`, and `spec/routing` (routing asserts the preview surface is absent outside development).
