# frozen_string_literal: true

# Demo banner component. Showcases the starter conventions: declarative args via
# `Dry::Initializer` (`option :title`) and component-scoped i18n (`t(".key")`
# resolving under `en.view_components.banner.*`), plus relative rendering of a
# nested component with `component ".badge"`.
class Banner::Component < ApplicationViewComponent
  option :title

  def eyebrow
    t(".eyebrow")
  end

  def badge_label
    t(".badge")
  end
end
