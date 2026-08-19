# frozen_string_literal: true

# Base class for the application's notifications — the unified delivery layer.
# A subclass implements `#deliver`; `.deliver` is the single entry point callers
# use. Concrete notifications own which channels they send on, so the base stays
# channel-agnostic and new channels slot in without the producing code changing.
class ApplicationNotification
  def self.deliver(...)
    new(...).deliver
  end
end
