# frozen_string_literal: true

# Bare radio button. Renders the `<input type="radio">` element for a named
# group; grouping/selected state is the caller's concern.
class Forms::Radio::Component < ApplicationViewComponent
  option :name
  option :value
  option :checked, default: -> { false }

  def root_options
    element_attrs(
      type: "radio",
      name: name,
      value: value,
      checked: checked,
      class: "radio"
    )
  end
end
