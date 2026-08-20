# frozen_string_literal: true

# Thin wrapper that labels a form control (yielded as a block) and surfaces an
# error message, delegating layout styling to daisyUI utility classes.
class Forms::Field::Component < ApplicationViewComponent
  option :label
  option :error_message, default: -> { nil }
end
