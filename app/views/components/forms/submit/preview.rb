# frozen_string_literal: true

# Preview the submit button at /lookbook.
class Forms::Submit::Preview < ApplicationViewComponentPreview
  def default
    render Forms::Submit::Component.new(label: "Sign in")
  end
end
