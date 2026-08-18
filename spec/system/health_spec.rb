# frozen_string_literal: true

# Tracer system spec: drives a real page through a real headless browser to prove
# the full harness (RSpec + Capybara + Cuprite + the app server) is wired end to end.
RSpec.describe "Health check", type: :system do
  it "serves a live page through a headless browser" do
    visit "/up"

    expect(page.status_code).to eq(200)
    expect(page.body).to be_present
  end
end
