# frozen_string_literal: true

# Submit control for forms, styled with daisyUI. Renders a real `<button
# type="submit">` so it submits its enclosing form (no separate form builder
# needed) while carrying the primary action styling. The daisyUI button variant
# is declared with StyleVariants (`style do ... end`), reconciled via the base's
# tailwind_merge postprocessor.
class Forms::Submit::Component < ApplicationViewComponent
  option :label
  option :variant, default: -> { :primary }

  style do
    base { %w[btn w-full] }
    variants {
      variant {
        primary { %w[btn-primary] }
        outline { %w[btn-outline] }
        ghost { %w[btn-ghost] }
      }
    }
    defaults { { variant: :primary } }
  end

  def root_options
    element_options(
      type: "submit",
      class: style(variant: variant)
    )
  end
end
