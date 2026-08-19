# frozen_string_literal: true

# Preview the nav at /lookbook, signed out. Auth-aware links react to the
# browser's live session; under Lookbook there is none, so a guest preview is
# the honest, deterministic showcase.
class Nav::Preview < ApplicationViewComponentPreview
  def default
    render_component Nav::Component.new
  end
end
