# frozen_string_literal: true

# Preview the field wrapper at /lookbook, with and without an error.
class Forms::Field::Preview < ApplicationViewComponentPreview
  def default
    render_component Forms::Field::Component.new(label: "Email address") do
      "<input type='email' class='input input-bordered' placeholder='you@example.com'>".html_safe
    end
  end

  def with_error
    render_component Forms::Field::Component.new(label: "Email address", error_message: "can't be blank") do
      "<input type='email' class='input input-bordered input-error'>".html_safe
    end
  end
end
