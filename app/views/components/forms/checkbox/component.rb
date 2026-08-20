# frozen_string_literal: true

# Bare checkbox. Renders the `<input type="checkbox">` element; a hidden
# twin is omitted (Rails' `check_box` helper injects one — here the caller
# decides, keeping this a pure presentational element).
class Forms::Checkbox::Component < ApplicationViewComponent
  option :name
  option :value, default: -> { "1" }
  option :checked, default: -> { false }
  option :input_html, default: -> { {} }

  def html_options
    input_html.merge(
      type: "checkbox",
      name: name,
      value: value,
      checked: checked
    )
  end
end
