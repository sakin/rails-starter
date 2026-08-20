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
floating label is the first demonstration, wired with `data-controller="<%= controller_name %>"`.

## Considered options

- **A wrapper named `Forms::Control`** — rejected: "form control" already means
  the input element in web semantics, so it inverted the intended label-vs-input split.
- **Native label/control split in the builder (`f.text_field` bare + `f.field`
  block)** — deferred: field-inclusive overrides give one-call ergonomics for the
  common case; the split remains a later additive since the wrapper is `Forms::Field`
  either way.
- **Component controllers in `app/frontend/controllers/`** — rejected: it split a
  component's behaviour from its folder and forced hand-maintained ids.

## Consequences

- Existing auth render sites migrated from `component "form_field"` /
  `"submit_button"` to `component "forms/field"` / `"forms/submit"`.
- `Forms::Form` staying dumb + `FormBuilder` owning fields means `form_with` and
  standalone rendering coexist without a builder-aware `<form>` component.
- `range`, `rating`, `file-input` are deferred beyond the core six.
- A view component may now ship a JS controller, so `app/views/components/` is no
  longer pure server concern — documented in directory-conventions.md.
