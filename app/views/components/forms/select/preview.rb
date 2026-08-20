# frozen_string_literal: true

# Preview the select at /lookbook.
class Forms::Select::Preview < ApplicationViewComponentPreview
  def default
    render_component Forms::Select::Component.new(
      name: "status",
      options: [ %w[Active active], %w[Archived archived] ]
    )
  end
end
