# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Authentication guarding", type: :request do
  describe "protected pages" do
    it "redirects a guest to sign-in" do
      get account_path
      expect(response).to redirect_to(new_session_path)
    end

    it "remembers where the guest wanted to go and returns there after sign-in" do
      get account_path
      follow_redirect!

      post session_path, params: { email_address: create(:user).email_address, password: "password" }
      expect(response).to redirect_to(account_path)
    end

    it "lets a signed-in person through" do
      user = create(:user)
      post session_path, params: { email_address: user.email_address, password: "password" }

      get account_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.email_address)
    end
  end

  describe "public pages" do
    it "are reachable without signing in" do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end
end
