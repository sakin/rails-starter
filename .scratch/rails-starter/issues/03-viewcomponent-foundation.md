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

Adopted `view_component` 4 + `view_component-contrib` (base classes, sidecarable previews, component-scoped i18n) + `dry-initializer` + `lookbook` (dev-only). Realigned to the PRD's §4.3 conventions (differs from the contrib gem's `app/frontend/components` default by design — see PRD §3, which reserves that path for JS-framework components).

- Sidecar convention under `app/views/components/<name>/` with `component.rb`, `component.html.erb`, `preview.rb`, `styles.css` (exactly the PRD §4.3 set — no per-component JS; styles are bundled by an entrypoint glob over `**/styles.css`).
- Base classes `ApplicationViewComponent` (extends `Dry::Initializer`, includes `DbQueryGuard` + `ComponentsHelper`) and `ApplicationViewComponentPreview`.
- `component "name", ...` view helper and relative `component ".nested"` rendering (inside a component), resolving under the enclosing namespace; demo `Banner` renders nested `Banner::Badge` relatively.
- Declarative args via `option :name` (dry-initializer).
- Custom generator `rails generate view_component NAME [attrs]` (`lib/generators/view_component`, a `NamedBase`) emitting component, template, preview, `styles.css`, and a `:view_component` spec.
- Component-scoped i18n via contrib (`t(".key")` → `en.view_components.<scope>`).
- `DbQueryGuard` raises `DbQueryGuard::UncheckedQueryError` when a component fires SQL during render unless it sets `self.allow_db_queries = true` (upstream `raise_on_db_queries` was removed in ViewComponent 4).
- Lookbook mounted only when `Rails.env.development?` at `/lookbook` (the PRD's `LOOKBOOK_ENABLED`/`/dev/lookbook` flag is deferred; see 10). Entrypoint globs `app/views/components/**/styles.css` so nested component styles bundle.

Specs at `spec/views/components` (type `:view_component`), `spec/generators`, and `spec/routing` (routing asserts the preview surface is absent outside development).
