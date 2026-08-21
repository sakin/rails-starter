# ADR-0003 — Forms as view components: a dumb `Forms::Form`, a `FormBuilder`, and co-located Stimulus controllers

## Status

Accepted.

## Context

The starter shipped two flat form primitives — `FormField` (label + control +
error wrapper) and `SubmitButton` — plus raw daisyUI classes in every auth form.
As the reference for new projects, we wanted one coherent, opinionated way to
build forms and their inputs as view components, and to demonstrate per-component
Stimulus controllers. This replaces the two flat primitives.

## Decision

Introduce a `Forms::*` view-component family under `app/views/components/forms/`
and re-home the old primitives inside it:

- **`Forms::Field`** (was `FormField`) labels/wraps a yielded control and surfaces errors.
- **`Forms::Submit`** (was `SubmitButton`) renders the submit button.
- **Bare typed controls** render only their `<input>`/`<select>`/`<textarea>`
  element from passed attrs: `Forms::Text`, `Forms::Textarea`, `Forms::Select`,
  `Forms::Checkbox`, `Forms::Radio`, `Forms::Toggle` (the core ground per the README).
- **`Forms::Form`** is a *dumb* `<form>` renderer — it takes `action`/`method`/
  html opts and yields; it knows nothing about builders or fields and composes
  independently.

**Two parallel render paths that never conflict:**
- **Standalone** — `component "forms/field"`, `component "forms/select", ...` from any view.
- **`FormBuilder`** (`lib/form_builder.rb`, `FormBuilder < ActionView::Helpers::FormBuilder`,
  reached via `form_with(builder: FormBuilder)`) — **field-inclusive overrides**
  for all six controls (`text_field`, `text_area`, `select`, `check_box`,
  `radio_button`, `toggle`) plus `submit`: `f.text_field :email, label: "Email"`
  composes `Forms::Field` + `Forms::Text` in one call; `label: false` opts out.
  `form_with` still owns the `<form>` tag. `lib/` is the home because a form
  builder is framework tooling, not a domain form object — `app/forms/` stays
  reserved for screen-specific form objects per directory-conventions.md.

**Co-located Stimulus controllers:** a component's controller ships beside it
(`app/views/components/forms/text/component_controller.js`) rather than in
`app/frontend/controllers/`. The entrypoint globs these and registers each by
folder path (`/` → `--`), so the id always equals the component's `controller_name`
(no special-casing between server CSS tokens and client controllers). Flat
standalone controllers (`theme`, `hello`) are unchanged. The `Forms::Text`
floating label is the first demonstration, wired with `data-controller="<%= controller_name %>"`,
and is exercised by a real-browser system test (`spec/system/forms/floating_label_spec.rb`)
driving the loaded Stimulus controller, not just a markup assertion.

**Common component arguments** (`app/views/components/application_view_component.rb`):
every component accepts `attrs:` (pass-through HTML attrs) plus the promoted
`class:`, `id:`, and `data:`. `element_options(defaults)` merges them into the
root element's attribute hash: component defaults and style-variant classes first,
then caller `class:`/`attrs[:class]`, then deep-merged `data:`/`attrs[:data]`,
so a caller's classes/data always override the component while its daisyUI classes
are preserved.

**StyleVariants on the base** (`include ViewComponentContrib::StyleVariants`,
postprocessed by `tailwind_merge`): a declarative `style do ... end` DSL replaces
hand-joined class strings for a component's visual variants. `Forms::Submit`
(`:primary` / `:outline` / `:ghost`) is the proof. `tailwind_merge` reconciles
Tailwind utility conflicts (caller wins); daisyUI classes are not utilities and
pass through on a last-wins join, so the merger's value is utility dedupe plus the
declarative variant structure — not daisyUI conflict resolution.

**Opinionated previews:** `Forms::Preview` renders the whole family through a
sidecar `preview.html.erb` template using the same `component` calls the app uses,
so Lookbook output matches app output (and the nested controls actually render).

## Considered options

- **A wrapper named `Forms::Control`** — rejected: "form control" already means
  the input element in web semantics, so it inverted the intended label-vs-input split.
- **Native label/control split in the builder (`f.text_field` bare + `f.field`
  block)** — deferred: field-inclusive overrides give one-call ergonomics for the
  common case; the split remains a later additive since the wrapper is `Forms::Field`
  either way.
- **Component controllers in `app/frontend/controllers/`** — rejected: it split a
  component's behaviour from its folder and forced hand-maintained ids.
- **Style Variants deferred** — this was the earlier hesitation (daisyUI already
  supplies the variant classes); we kept it after all for the declarative variant
  shape and utility-conflict reconciliation. If it shows no value later, the
  include is a one-line removal — a starter-appropriate "keep the capability, prove
  it small" trade-off.
- **Preview templates vs `render_component`** — the composite `Forms::Preview`
  can't hand-join nested component renders, so a preview template (which renders
  like the app) was chosen over a hand-assembled block. Single-component previews
  keep the simpler `render_component`.

## Consequences

- Existing auth render sites migrated from `component "form_field"` /
  `"submit_button"` to `component "forms/field"` / `"forms/submit"`.
- `Forms::Form` staying dumb + `FormBuilder` owning fields means `form_with` and
  standalone rendering coexist without a builder-aware `<form>` component.
- `range`, `rating`, `file-input` are deferred beyond the core six.
- A view component may now ship a JS controller, so `app/views/components/` is no
  longer pure server concern — documented in directory-conventions.md.
