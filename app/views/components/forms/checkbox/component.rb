# frozen_string_literal: true

# Bare checkbox. Renders the `<input type="checkbox">` element; a hidden
# twin is omitted (Rails' `check_box` helper injects one — here the caller
# decides, keeping this a pure presentational element).
class Forms::Checkbox::Component < ApplicationViewComponent
  option :name
  option :value, default: -> { "1" }
  option :checked, type: Dry::Types["params.bool"], default: -> { false }

  def root_options
    element_attrs(
      type: "checkbox",
      name: name,
      value: value,
      checked: checked,
      class: "checkbox"
    )
  end
end
