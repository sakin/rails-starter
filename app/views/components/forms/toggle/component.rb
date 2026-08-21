# frozen_string_literal: true

# Bare toggle (daisyUI switch/checkbox). Renders the `<input type="checkbox">`
# element; visual switch styling is daisyUI's `toggle` class applied here.
class Forms::Toggle::Component < ApplicationViewComponent
  option :name
  option :value, default: -> { "1" }
  option :checked, default: -> { false }

  def root_options
    element_options(
      type: "checkbox",
      name: name,
      value: value,
      checked: checked,
      class: "toggle"
    )
  end
end
