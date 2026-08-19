# frozen_string_literal: true

require "rails_helper"

# The default layout (Layout::Component) is exercised through real requests: it
# is only meaningfully rendered with a request context (CSRF, CSP and Vite head
# helpers). These specs assert that every page shares the nav and flash region.
RSpec.describe "Default layout", type: :request do
  it "renders the shared nav and flash region on a public page" do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("c-nav-root")
    expect(response.body).to include("c-flash-root")
    expect(response.body).to include("c-layout-main")
  end

  it "applies the document title for the app" do
    get root_path

    expect(response.body).to include("<title>Rails Starter</title>")
  end

  it "shows guest auth actions in the nav when signed out" do
    get root_path

    expect(response.body).to include(new_session_path)
    expect(response.body).to include(new_registration_path)
  end

  it "shows the account and sign-out actions in the nav when signed in" do
    user = create(:user)
    post session_path, params: { email_address: user.email_address, password: "password" }
    get root_path

    expect(response.body).to include(account_path)
    expect(response.body).to include("Sign out")
    expect(response.body).not_to include(new_session_path)
  end
end
