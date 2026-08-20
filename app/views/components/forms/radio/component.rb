# frozen_string_literal: true

# Bare radio button. Renders the `<input type="radio">` element for a named
# group; grouping/selected state is the caller's concern.
class Forms::Radio::Component < ApplicationViewComponent
  option :name
  option :value
  option :checked, default: -> { false }
  option :input_html, default: -> { {} }

  def html_options
    input_html.merge(
      type: "radio",
      name: name,
      value: value,
      checked: checked
    )
  end
end
