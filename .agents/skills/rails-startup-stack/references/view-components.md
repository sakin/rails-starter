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
- **`FormBuilder`** (`lib/form_builder.rb`) — map a `form_with` block onto the
  family with **field-inclusive overrides**: `form.text_field :email, label: "Email"` composes `Forms::Field` + `Forms::Text` in one call. Opt out of the wrapper with `label: false`. Pass it explicitly: `form_with model: @x, builder: FormBuilder`.
- **The split stays clean** — `form_with` emits the `<form>` tag itself (with its own builder); `Forms::Form` is only for standalone rendering. The two never conflict.

`Forms::Field` also covers the common error path (pass `error_message:` or let the builder pull `object.errors[:attr].first`).

## Co-located Stimulus controllers

A view component that needs client behaviour ships its Stimulus controller in
its own folder, not in `app/frontend/controllers/`:

```
app/views/components/forms/text/
├── component.rb
├── component.html.erb
├── preview.rb
├── styles.css
└── component_controller.js      → registered as forms--text
```

The entrypoint auto-globs any `<folder>/*_controller.js` under
`app/views/components/` and registers it by folder path (`/` → `--`), so the
id always matches the component's `controller_name`. `component_controller.js`
is the default id (`forms/text/` → `forms--text`); a second controller there
named `foo_controller.js` registers as `forms--text--foo`. Wire it from the
component with `data-controller="<%= controller_name %>"` (see the `Forms::Text`
floating-label example). Flat standalone controllers (`app/frontend/controllers/`)
are unaffected — see [directory-conventions.md](directory-conventions.md).

## Lookbook

Mounted at `/lookbook` **development-only** (see `config/routes.rb`). Previews
render there as living docs; mailer previews are also covered via
`app/views/components/mailer/`. `Forms::Preview` documents the whole family in
one scene. Never referenced in production.
