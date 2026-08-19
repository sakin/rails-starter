# frozen_string_literal: true

# Preview the flash region at /lookbook. Messages are passed explicitly here so
# the preview is deterministic regardless of the ambient request flash.
class Flash::Preview < ApplicationViewComponentPreview
  def default
    render_component Flash::Component.new(
      messages: { notice: "Everything worked.", alert: "Something went wrong." }
    )
  end
end
