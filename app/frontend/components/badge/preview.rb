# frozen_string_literal: true

# Preview this component at /lookbook. The preview class lives in the same
# sidecar folder and inherits the shared preview base.
class Badge::Preview < ApplicationViewComponentPreview
  def default
    render_component Badge::Component.new(label: "ViewComponent")
  end
end
