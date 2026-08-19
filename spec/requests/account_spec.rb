# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account authorization", type: :request do
  let(:user) { create(:user) }

  before do
    post session_path, params: { email_address: user.email_address, password: "password" }
  end

  describe "GET /account" do
    it "serves the signed-in person their own account (authorized branch)" do
      get account_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.email_address)
    end

    it "forbids requesting another person's account (denied branch)" do
      other = create(:user)

      get account_path, params: { user_id: other.id }

      expect(response).to have_http_status(:forbidden)
    end

    it "still redirects a guest to sign-in (authentication guard runs first)" do
      delete session_path # sign out
      get account_path

      expect(response).to redirect_to(new_session_path)
    end
  end
end
