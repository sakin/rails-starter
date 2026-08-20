# frozen_string_literal: true

# Submit control for forms, styled with daisyUI. Renders as a real `<button
# type="submit">` so it submits its enclosing form (no separate form builder
# needed) while carrying the primary action styling.
class Forms::Submit::Component < ApplicationViewComponent
  option :label
end
