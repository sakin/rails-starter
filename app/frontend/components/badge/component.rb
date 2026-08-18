# frozen_string_literal: true

# Small labelled pill, nested inside other components (see Banner::Component).
class Badge::Component < ApplicationViewComponent
  def initialize(label:)
    @label = label
  end

  attr_reader :label
end
