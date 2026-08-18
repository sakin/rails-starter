# frozen_string_literal: true

# Demo banner component. Showcases the conventions the generator stamps out:
# an explicit, typed initializer and component-scoped i18n via `t(".key")`,
# which resolves under `en.view_components.banner.*`.
class Banner::Component < ApplicationViewComponent
  def initialize(title:)
    @title = title
  end

  attr_reader :title

  def eyebrow
    t(".eyebrow")
  end

  def badge_label
    t(".badge")
  end
end
