# frozen_string_literal: true

# Preview the form-field wrapper at /lookbook, with and without an error.
class FormField::Preview < ApplicationViewComponentPreview
  def default
    render_component FormField::Component.new(label: "Email address") do
      "<input type='email' class='input input-bordered' placeholder='you@example.com'>".html_safe
    end
  end

  def with_error
    render_component FormField::Component.new(label: "Email address", error_message: "can't be blank") do
      "<input type='email' class='input input-bordered input-error'>".html_safe
    end
  end
end
