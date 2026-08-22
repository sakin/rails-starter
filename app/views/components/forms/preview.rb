# frozen_string_literal: true

# Preview the full forms family assembled into one `<form>` at /lookbook. Renders
# through the same `component` helper the app uses (opinionated previews, so Lookbook
# output == app output) and composes all six typed inputs plus the submit button.
#
# `builder` shows the same family produced through `form_with` (which uses the
# app-wide `ApplicationFormBuilder` default) — the field-inclusive path in which
# `f.text_field :email, label: "Email"` composes `Forms::Field` + control.
class Forms::Preview < ApplicationViewComponentPreview
  def default
    render_with
  end

  def builder
    render_with
  end
end
