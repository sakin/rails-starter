# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registration sign-up", type: :request do
  describe "GET /registration/new" do
    it "is reachable without signing in" do
      get new_registration_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /registration" do
    it "creates an account and signs the person in immediately" do
      expect {
        post registration_path, params: {
          registration: { email_address: "sara@example.com", password: "password" }
        }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
    end

    it "queues a welcome email on sign-up" do
      expect {
        post registration_path, params: {
          registration: { email_address: "sara@example.com", password: "password" }
        }
      }.to have_enqueued_mail(NotificationsMailer, :welcome).with(User.last)
    end

    it "sets a session cookie so the account is authenticated right away" do
      post registration_path, params: {
        registration: { email_address: "sara@example.com", password: "password" }
      }

      expect(cookies[:session_id]).to be_present
      expect(Session.last.user.email_address).to eq("sara@example.com")
    end

    it "re-renders the form with errors and creates nothing on invalid input" do
      expect {
        post registration_path, params: {
          registration: { email_address: "", password: "" }
        }
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Email")
      expect(cookies[:session_id]).to be_nil
    end

    it "keeps the submitted email on re-render (no state drift)" do
      post registration_path, params: {
        registration: { email_address: "sara@example.com", password: "" }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("sara@example.com")
    end

    it "re-renders the form with errors when the email is a duplicate" do
      create(:user, email_address: "taken@example.com")

      expect {
        post registration_path, params: {
          registration: { email_address: "taken@example.com", password: "password" }
        }
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
