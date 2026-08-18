# frozen_string_literal: true

require "webmock/rspec"

# Tests must be stub-friendly: no real outbound HTTP in the suite. Requests to
# localhost (e.g. Capybara's app server) are still allowed so system specs work.
WebMock.disable_net_connect!(allow_localhost: true)
