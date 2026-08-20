# frozen_string_literal: true

# Preview the checkbox at /lookbook.
class Forms::Checkbox::Preview < ApplicationViewComponentPreview
  def default
    render_component Forms::Checkbox::Component.new(name: "subscribe", checked: true)
  end
end
