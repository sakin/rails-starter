# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Password reset", type: :request do
  let(:user) { create(:user) }

  describe "GET /passwords/new" do
    it "is reachable without signing in" do
      get new_password_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /passwords" do
    it "sends reset instructions for a known email address" do
      expect {
        post passwords_path, params: { email_address: user.email_address }
      }.to have_enqueued_email(PasswordsMailer, :reset).with(user)

      expect(response).to redirect_to(new_session_path)
    end

    it "redirects silently (no enqueued mail) for an unknown email address" do
      expect {
        post passwords_path, params: { email_address: "missing@example.com" }
      }.not_to have_enqueued_email(PasswordsMailer)

      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "GET /passwords/:token/edit" do
    it "lets a person with a valid token reach the edit form" do
      get edit_password_path(user.password_reset_token)
      expect(response).to have_http_status(:ok)
    end

    it "rejects an invalid token" do
      get edit_password_path("bogus")
      expect(response).to redirect_to(new_password_path)
    end
  end

  describe "PUT /passwords/:token" do
    it "updates the password and revokes all sessions" do
      token = user.password_reset_token
      create(:session, user: user)

      expect { put password_path(token), params: { password: "newpassword", password_confirmation: "newpassword" } }
        .to change { user.reload.password_digest }
        .and change(user.sessions, :count).to(0)

      expect(response).to redirect_to(new_session_path)
      expect(User.authenticate_by(email_address: user.email_address, password: "newpassword")).to eq(user)
    end

    it "rejects mismatched passwords without changing the digest" do
      token = user.password_reset_token
      original = user.password_digest

      expect {
        put password_path(token), params: { password: "newpassword", password_confirmation: "different" }
      }.not_to(change { user.reload.password_digest })

      expect(response).to redirect_to(edit_password_path(token))
    end
  end
end
