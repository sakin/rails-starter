# frozen_string_literal: true

# One flash region rendered by the default layout. Delegates to daisyUI alert
# classes and maps the conventional flash types onto them: `notice` reads as
# success, anything else (e.g. `alert`) reads as an error.
class Flash::Component < ApplicationViewComponent
  option :messages, default: -> { {} }

  def entries
    if messages.any?
      messages.to_a
    else
      helpers.flash.to_a
    end
  end

  def alert_class(type)
    type.to_s == "notice" ? "alert-success" : "alert-error"
  end
end
