# frozen_string_literal: true

require "isolator"

# Non-atomic-IO guard for the test suite. Isolator raises whenever code triggers
# a side effect that must not appear inside a database transaction — background
# job enqueues, mail deliveries, outbound HTTP, cache writes, etc. Because the
# whole suite runs under transactional fixtures, this wiring is what actually
# trips on a violation: if a spec (or the code path it exercises) performs such
# IO while a transaction is open, the example fails loudly instead of silently
# coupling the side effect to a transaction that may still roll back.
Isolator.configure do |config|
  # Offenses are hard errors in the suite (this is Isolator's test default).
  config.raise_exceptions = true

  # Ensure a short, relevant offender backtrace at most.
  config.backtrace_filter = ->(backtrace) { backtrace.take(5) }
end
