# 06 — Default layout + UI primitives

**What to build:** every page renders through a default component layout assembled from a small set of thin daisyUI wrapper components (nav, flash, form field, submit button), and the nav switches the app between light and dark themes.

**Blocked by:** 03 — ViewComponent foundation + contrib + Lookbook, 04 — Auth core

**Status:** resolved

- [x] A default layout component renders all pages with a shared nav and flash region.
- [x] The wrapper components delegate their styling to daisyUI classes and stay thin in source.
- [x] The nav exposes a light/dark toggle that persists and restyles the app.
- [x] Each primitive has a Lookbook preview; the auth pages (incl. flash on sign-in/out) render through the layout.

## Answer

Every page now renders through `Layout::Component` — a single default layout that owns the full HTML document (head meta/CSRF/CSP/Vite tags plus a nav + flash region) and yields the page body as main content. It is wired from `app/views/layouts/application.html.erb`, so the auth pages (sign-in, sign-up, password reset) all render through it automatically.

- **Primitives** under `app/views/components/`: `Layout`, `Nav`, `Flash`, `FormField`, `SubmitButton` — each with `component.rb`/`component.html.erb`/`preview.rb`/`styles.css`, `Dry::Initializer` args, `class_for`-scoped CSS that delegates to daisyUI utility classes, and a Lookbook preview. Components stay DB-free: auth state is read from `Current.session`.
- **Theme toggle**: a Stimulus controller (`theme_controller.js`) applies the chosen daisyUI `light`/`dark` theme as `data-theme` on the document root and persists it in `localStorage` (defaulting to the OS preference). The Nav hosts the toggle; styles.rebuild includes the controller.
- **Auth views** were rewritten onto the primitives (forms use `FormField` + `SubmitButton`, inline flash markup removed in favour of the layout's `Flash` region). Sessions specs assert the failed-sign-in flash renders as a styled `alert-error` inside the layout.

Two supporting fixes surfaced along the way:

- **Auth state before render**: `Authentication` now loads the session on every request (not just protected ones) and eager-loads the user, so the guarded layout/nav can read identity (`Current.session` / `Current.user`) without firing queries during view render — which `DbQueryGuard` would otherwise reject.
- **Stimulus identifier derivation**: the frontend entrypoint computed controller names from a path that never matched `/Controller$/` (the `.js` suffix kept it from stripping), so every controller registered under e.g. `theme_controller.js` instead of `theme`. Fixed to derive `theme_controller.js` → `theme`, which the toggle depends on.

Specs: `spec/views/components/{layout was dropped, nav, flash, form_field, submit_button}_component_spec.rb`, `spec/requests/layout_spec.rb` (nav + flash + signed-in/out branches), an added flash-through-layout assertion in `spec/requests/sessions_spec.rb`, and `spec/system/theme_spec.rb` (toggle + persistence).
