# frozen_string_literal: true

# Preview the toggle at /lookbook.
class Forms::Toggle::Preview < ApplicationViewComponentPreview
  def default
    render Forms::Toggle::Component.new(name: "enabled", checked: true)
  end
end
