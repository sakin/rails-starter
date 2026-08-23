# frozen_string_literal: true

# Preview this component at /lookbook. The preview class lives in the same
# sidecar folder and inherits the shared preview base.
class Banner::Preview < ApplicationViewComponentPreview
  def default
    render Banner::Component.new(title: "Welcome")
  end
end
