# frozen_string_literal: true

# Bare toggle (daisyUI switch/checkbox). Renders the `<input type="checkbox">`
# element; visual switch styling is a daisyUI class applied by the caller.
class Forms::Toggle::Component < ApplicationViewComponent
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
