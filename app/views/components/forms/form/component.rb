# frozen_string_literal: true

# Dumb `<form>` renderer. Owns only the element tag (action, method, and the
# base attrs); it knows nothing about form builders or fields. Content is yielded
# as a block, so callers stay free to use `form_with`, raw inputs, or this forms family.
class Forms::Form::Component < ApplicationViewComponent
  option :action
  option :method, default: -> { :post }

  def root_options
    element_attrs(action: action, method: method)
  end
end
