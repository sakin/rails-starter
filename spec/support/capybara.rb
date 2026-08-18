# frozen_string_literal: true

# System-test browser driver: Cuprite drives the locally installed Chromium/Chrome
# over the Chrome DevTools Protocol (via Ferrum) — no chromedriver binary to
# version-match and no Node anywhere. Set HEADLESS=0 to open the browser window
# for debugging.
#
# The driver is registered and selected centrally here, so it's the single
# swap-seam for browser automation: specs only ever call Capybara's `visit`, never
# a driver API. To adopt a different driver (e.g. Selenium), register it here and
# flip Capybara.default_driver / javascript_driver.
Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [ 1920, 1080 ],
    js_errors: true,
    # Headless by default; open a window when HEADLESS=0/false/no.
    headless: %w[0 false no].exclude?(ENV.fetch("HEADLESS", "1")),
    browser_options: { "no-sandbox" => nil } # required in some containerised CI
  )
end

Capybara.default_driver = :cuprite
Capybara.javascript_driver = :cuprite

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :cuprite
  end
end
