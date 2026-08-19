# 13 — README, docs, glossary, and ADRs

**What to build:** documentation a fresh user actually needs — directory conventions, how to escalate the frontend tooling, how to swap to Postgres, the next-tier gem list, and the template-usage checklist — plus the shared glossary and the two architecture decisions.

**Blocked by:** 02 — Frontend swap: Vite + bundlebun + Tailwind v4 + daisyUI 5, 04 — Auth core, 06 — Default layout + UI primitives, 09 — Docker build + optional Kamal config

**Status:** resolved

- [x] The README documents directory conventions, the frontend escalation ladder with how-to-add for each rung, the SQLite-to-Postgres swap, the next-tier gems, and the template-use checklist (incl. rename and credentials).
- [x] A glossary captures the starter/template/project vocabulary.
- [x] Two ADRs record the frontend-build choice and the authentication choice.
- [x] The README notes Kamal's optionality and the Litestream accessory alternative.

## Note (03 realignment)

Document the view layer per PRD §3/§4.3: ViewComponents live in
`app/views/components` (sidecar: `component.rb`, `component.html.erb`, `preview.rb`,
`styles.css`, bundled by an entrypoint glob), rendered via the `component "name"` helper and relative
`component ".nested"` inside components, with `Dry::Initializer` args and
`class_for`-scoped CSS. The `component`/`dry-initializer`/relative-rendering choices
now differ from the view_component-contrib gem defaults (which use
`app/frontend/components`), so document the reasoning.
