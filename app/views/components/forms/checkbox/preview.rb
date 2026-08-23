# frozen_string_literal: true

# Preview the checkbox at /lookbook.
class Forms::Checkbox::Preview < ApplicationViewComponentPreview
  def default
    render Forms::Checkbox::Component.new(name: "subscribe", checked: true)
  end
end
