# frozen_string_literal: true

# Preview the submit button at /lookbook.
class SubmitButton::Preview < ApplicationViewComponentPreview
  def default
    render_component SubmitButton::Component.new(label: "Sign in")
  end
end
