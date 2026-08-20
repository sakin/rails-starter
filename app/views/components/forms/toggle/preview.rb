# frozen_string_literal: true

# Preview the toggle at /lookbook.
class Forms::Toggle::Preview < ApplicationViewComponentPreview
  def default
    render_component Forms::Toggle::Component.new(name: "enabled", checked: true)
  end
end
