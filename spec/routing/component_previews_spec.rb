# frozen_string_literal: true

# Component previews (Lookbook + the ViewComponent preview surface) must only be
# reachable when explicitly enabled. Outside development the routes are drawn
# without the mount, so the surface must not exist at all.
RSpec.describe("Component preview gating", type: :routing) do
  it "does not route /lookbook in the test environment" do
    expect {
      Rails.application.routes.recognize_path("/lookbook", method: :get)
    }.to raise_error(ActionController::RoutingError)
  end
end
