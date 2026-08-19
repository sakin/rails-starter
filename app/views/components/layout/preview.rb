# frozen_string_literal: true

# Preview the default layout at /lookbook. Provides a block so the full page
# shell (nav + flash + main) renders around example body content.
class Layout::Preview < ApplicationViewComponentPreview
  def default
    render_component Layout::Component.new(title: "Rails Starter") do
      "<p>Example page content rendered through the default layout.</p>".html_safe
    end
  end
end
