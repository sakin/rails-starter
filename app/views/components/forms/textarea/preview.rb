# frozen_string_literal: true

# Preview the textarea at /lookbook.
class Forms::Textarea::Preview < ApplicationViewComponentPreview
  def default
    render_component Forms::Textarea::Component.new(name: "message", value: "Hello world")
  end
end
