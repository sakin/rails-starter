# frozen_string_literal: true

# Abstract base for Lookbook / ViewComponent previews. Marked abstract so it
# never shows in the preview index; concrete preview classes inherit from it.
class ApplicationViewComponentPreview < ViewComponentContrib::Preview::Base
  self.abstract_class = true
end
