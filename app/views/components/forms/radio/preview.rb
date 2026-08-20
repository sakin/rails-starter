# frozen_string_literal: true

# Preview the radio button at /lookbook.
class Forms::Radio::Preview < ApplicationViewComponentPreview
  def default
    render_component Forms::Radio::Component.new(name: "plan", value: "pro")
  end
end
