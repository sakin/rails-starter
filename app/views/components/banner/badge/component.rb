# frozen_string_literal: true

# Small labelled pill nested inside Banner. Rendered relatively from
# `Banner::Component` via `component ".badge", label: ...`.
class Banner::Badge::Component < ApplicationViewComponent
  option :label
end
