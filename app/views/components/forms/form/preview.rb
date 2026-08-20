# frozen_string_literal: true

# Preview the `<form>` element in isolation at /lookbook.
class Forms::Form::Preview < ApplicationViewComponentPreview
  def default
    render_component Forms::Form::Component.new(action: "/", method: :post) do
      "<input class='input input-bordered' placeholder='Example field'>".html_safe
    end
  end
end
