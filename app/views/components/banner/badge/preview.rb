# frozen_string_literal: true

# Preview this component at /lookbook. The preview class lives in the same
# sidecar folder and inherits the shared preview base.
class Banner::Badge::Preview < ApplicationViewComponentPreview
  def default
    render Banner::Badge::Component.new(label: "ViewComponent")
  end
end
