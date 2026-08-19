# Frontend escalation ladder

How to climb this starter's frontend tooling without re-architecting. Start
where the template leaves you and climb only as needed. Each rung keeps the
previous ones working; nothing above rung 1 changes the build or Docker.

The runtime is **Bun** (`bin/bun`, `bin/bun-vite`), shipped by `bundlebun`
in the RubyGems bundle — **no Node/npm/Yarn install step exists**, in dev, CI,
or the Docker build. CSS is Tailwind v4 + daisyUI 5, compiled by Vite.

## The ladder

| Rung | When | What to do |
|------|------|------------|
| 1. **Add a component** | Default for most UI | `bin/rails generate view_component name attrs`, then render from a view. No new tooling. |
| 2. **Add a Stimulus controller** | A small interactive behaviour | Drop `app/frontend/controllers/foo_controller.js`; auto-registered (identifier = filename). Recompile via the Vite watcher. |
| 3. **Style / theme** | Any styling need | Edit `app/frontend/entrypoints/application.css` (Tailwind v4 + daisyUI 5). Themes switch via the nav toggle (Stimulus `theme_controller.js`, persisted to `localStorage`). |
| 4. **Add an entrypoint** | New build target | List a file under `app/frontend/entrypoints/` and load it with `vite_javascript_tag` / `vite_stylesheet_tag` in the layout. |
| 5. **Adopt a JS framework** | A genuinely reactive page (Turbo Mount) or a full SPA (Inertia) | Mount on the **same Vite build** — same entrypoints, same `/components` model. `app/frontend/` is deliberately reserved for this; no frontend re-architecture required. |

## When to climb to a JS framework

- **Turbo Mount** — drop a single standalone React/Vue/Svelte component into a
  Turbo page. Only when a page needs one genuinely reactive component.
- **Inertia Rails** — full-SPA pages. Only when a page's state management
  outgrows Turbo Mount.

Both are explicitly **not installed** in v1 and are deferred per-project. Vite
Ruby being already in place is what makes each a drop-in addition. See
`docs/adr/0001-frontend-build.md` for the decision. The "next tier" framing is
also in the README.
