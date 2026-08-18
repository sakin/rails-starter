# frozen_string_literal: true

# Let preview classes live next to their component under a sidecar `preview.rb`
# (the upstream convention pins names to a `_preview.rb` suffix). Without this
# extension, `Banner::Preview` in `banner/preview.rb` would never be discovered.
ActiveSupport.on_load(:view_component) do
  ViewComponent::Preview.extend ViewComponentContrib::Preview::Sidecarable
end
