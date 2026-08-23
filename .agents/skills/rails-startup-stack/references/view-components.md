# View components

Server-rendered components under `app/views/components/<name>/`, each a sidecar
folder of `component.rb`, `component.html.erb`, `preview.rb`, and `styles.css`.
Built on `view_component` + `view_component-contrib` with `dry-initializer`
typed args and a custom `component` helper. The layered-rails
[view-components topic](../../layered-rails/references/topics/view-components.md)
covers the *pattern*; this file is how it is wired here.

## The divergence to remember

The `view_component-contrib` gem defaults to `app/frontend/components`. This
starter deliberately diverges: it reserves `app/frontend/` for JS-framework
components (PRD §3), so server-rendered components live under
`app/views/components/` and use a custom `component` helper + `dry-initializer`
args + relative rendering rather than the gem's defaults. Keep that split when
adding components — a server component goes under `app/views/components`, never
`app/frontend`.

## Sidecar set

| File | Purpose |
|------|---------|
| `component.rb` | Args and logic. `Dry::Initializer` for declarative args (`option :title`). `ApplicationViewComponent` already includes `DbQueryGuard` + `ComponentsHelper` and defines `controller_name` / `class_for`. |
| `component.html.erb` | Template. References args; scopes root styles via `class_for("root")`. |
| `preview.rb` | Lookbook preview, doubles as living documentation. |
| `styles.css` | Sidecar styles, bundled by an entrypoint glob over `**/styles.css`. |

Render with the `component` helper:

```erb
<%= component "banner", title: "Hi" %>            <!-- absolute -->
<%= component "banner/badge", label: "New" %>     <!-- absolute, nested -->
<%= component ".badge", label: "New" %>           <!-- relative, inside Banner::Component -->
```

Relative `.name` resolves under the enclosing component's namespace. The helper
lives in `app/helpers/components_helper.rb`.

## Generator

```
bin/rails generate view_component Banner
bin/rails generate view_component Profile name age
bin/rails generate view_component admin/sidebar title
```

Checked-in generator at `lib/generators/view_component/` (per
`view_component-contrib` convention). Emits the four sidecar files plus a spec
under `spec/views/components/<name>_component_spec.rb` (specs live flat, one per
component folder mirrored).

## Base class

`ApplicationViewComponent < ViewComponentContrib::Base` already wires in:

- `component-scoped i18n` via `t(".key")` → `en.view_components.<scope>` and the
  `#wrapped` helper (from `ViewComponentContrib::Base`).
- `Dry::Initializer` — extend it in your component to declare args.
- `DbQueryGuard` — any DB query during render raises unless the component opts
  out with `self.allow_db_queries = true`.
- `class_for(token)` — a scoped CSS token (`c-<controller>-<token>`, e.g.
  `c-banner--badge-root`) so styles never collide across folders.
- `controller_name` — the Stimulus identifier (`Banner::Badge::Component` →
  `banner--badge`).
- `StyleVariants` (`style do ... end`) — a declarative DSL for class variants,
  reconciled by a `tailwind_merge` postprocessor (caller classes win; daisyUI
  classes pass through, Tailwind utilities conflict-resolve). First proof:
  `Forms::Submit` (`:primary` / `:outline` / `:ghost`).
- The common **component arguments** (`attrs`, `class`, `id`, `data`) and the
  `element_attrs(defaults)` merge — see [Component arguments](#component-arguments) below.

## Component arguments

Every component accepts four root-level arguments, merged by `element_attrs`
into one attribute hash for the root element (spread with `tag.attributes(**...)`
or passed to a tag helper):

| Arg | Semantics |
|-----|-----------|
| `attrs:` | Pass-through HTML attributes (`placeholder`, `required`, `data-*` beyond the promoted ones, `aria-*`, `test_id`, ...). |
| `class:` | Extra classes, joined over the component defaults and `attrs[:class]`, then Tailwind-merged (caller wins). |
| `id:` | Sugar for `attrs[:id]`; not merged, first provided wins. |
| `data:` | Deep-merged (caller wins per-key) over the component's own `data` and `attrs[:data]`. |

Merge order: **component defaults + `style(...)` variants first, then `class:`/`attrs[:class]`,
then `data:`/`attrs[:data]`**. So a caller's `class:`/`data:` always override the
component, while daisyUI classes are preserved. A component renders its own
essential options (e.g. `Forms::Text`'s `name`/`value`/`type`) and forwards the
rest of the caller's `attrs` unchanged. A component that *delegates* attributes
down to a child keeps a single `attrs` and may split into `input_attrs`-style
named bags only for that delegation.

## The forms family

Form inputs are their own component family under `app/views/components/forms/`
(a `Forms::*` namespace), per [ADR-0003](../../../docs/adr/0003-forms-components-and-builder.md):

| Component | Role |
|-----------|------|
| `Forms::Form` | Dumb `<form>` renderer (`action`, `method`, html opts). Yields; knows nothing about builders or fields. |
| `Forms::Field` | Label + control + error wrapper. Wraps any yielded control. |
| `Forms::Text` / `Textarea` / `Select` / `Checkbox` / `Radio` / `Toggle` | Bare typed controls. Render only their element from passed attrs. |
| `Forms::Submit` | `<button type="submit">` with daisyUI primary styling. |

### Rendering: standalone vs the builder

- **Standalone** — use the `component` helper anywhere: `component "forms/field"` (wraps a raw control), `component "forms/select", name: :x, options: [...]`, and so on.
- **`ApplicationFormBuilder`** (`lib/application_form_builder.rb`) — map a
  `form_with` block onto the family with **field-inclusive overrides**:
  `form.text_field :email, label: "Email"` composes `Forms::Field` + `Forms::Text`
  in one call. Opt out of the wrapper with `label: false`. It is set as the global
  default (`config.action_view.default_form_builder`), so `form_with` uses it
  everywhere without passing `builder:`.
- **The split stays clean** — `form_with` emits the `<form>` tag itself (with its own builder); `Forms::Form` is only for standalone rendering. The two never conflict.

`Forms::Field` also covers the common error path (pass `error_message:` or let the builder pull `object.errors[:attr].first`).

## Co-located Stimulus controllers

A view component that needs client behaviour ships its Stimulus controller in
its own folder, not in `app/frontend/controllers/`:

```
app/views/components/modal/
├── component.rb
├── component.html.erb
├── preview.rb
├── styles.css
└── component_controller.js      → registered as modal
```

The entrypoint auto-globs any `<folder>/*_controller.js` under
`app/views/components/` and registers it by folder path (`/` → `--`), so the
id always matches the component's `controller_name`. `component_controller.js`
is the default id (`modal/` → `modal`); a second controller there named
`foo_controller.js` registers as `modal--foo`. Wire it from the component with
`data-controller="<%= controller_name %>"`. `Modal` is the reference: a daisyUI
`<dialog>` opened/closed via `.showModal()`, driven by `data-action="click->modal#open"`.

**Don't add a controller when daisyUI can do it in CSS.** The `Forms::Text`
floating label is pure CSS under daisyUI's `floating-label` wrapper (float via
`:focus-within`/placeholder-shown) and ships **no** `component_controller.js`.
Flat standalone controllers (`app/frontend/controllers/`) are unaffected — see
[directory-conventions.md](directory-conventions.md).

## Lookbook

Mounted at `/lookbook` **development-only** (see `config/routes.rb`). Previews
render there as living docs; mailer previews are also covered via
`app/views/components/mailer/`. `Forms::Preview` documents the whole family in
one scene plus a `builder` scene via the default `ApplicationFormBuilder`;
`Modal::Preview` shows the JS-backed dialog. Never referenced in production.
