# frozen_string_literal: true

# Preview the full forms family assembled into one `<form>` at /lookbook. Composes
# all six typed inputs wrapped in `Forms::Field` plus the submit button, so the
# general shape of a form and every input variant is documented in one scene.
class Forms::Preview < ApplicationViewComponentPreview
  def default
    render_component Forms::Form::Component.new(action: "/", method: :post) do
      content = []
      content << field("Text input", Forms::Text::Component.new(name: "text"))
      content << field("Textarea", Forms::Textarea::Component.new(name: "textarea"))
      content << field("Select", Forms::Select::Component.new(
        name: "select",
        options: [ %w[Option\ one one], %w[Option\ two two] ]
      ))
      content << field("Checkbox", Forms::Checkbox::Component.new(name: "checkbox"))
      content << field("Radio", Forms::Radio::Component.new(name: "radio", value: "1"))
      content << field("Toggle", Forms::Toggle::Component.new(name: "toggle", checked: true))
      content << Forms::Submit::Component.new(label: "Submit")
      safe_join(content, "\n")
    end
  end

  private

  def field(label, control)
    Forms::Field::Component.new(label: label) { render(control) }
  end
end
