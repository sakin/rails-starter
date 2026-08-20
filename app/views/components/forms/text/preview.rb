# frozen_string_literal: true

# Preview the text input at /lookbook, with and without a floating label.
class Forms::Text::Preview < ApplicationViewComponentPreview
  def default
    render_component Forms::Text::Component.new(name: "email", placeholder: "you@example.com")
  end

  def floating_label
    render_component Forms::Text::Component.new(name: "email", floating_label: true, label: "Email address")
  end
end
