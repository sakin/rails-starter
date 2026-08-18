# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Session sign-in/sign-out", type: :request do
  let(:user) { create(:user) }

  describe "GET /session/new" do
    it "is reachable without signing in" do
      get new_session_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /session" do
    it "signs the person in and persists a database-backed session" do
      expect { post session_path, params: { email_address: user.email_address, password: "password" } }
        .to change(Session, :count).by(1)
        .and change(user.sessions, :count).by(1)

      expect(response).to redirect_to(root_path)
    end

    it "sets a signed session cookie and records the device context" do
      post session_path, params: { email_address: user.email_address, password: "password" }

      expect(cookies[:session_id]).to be_present
      session = Session.last
      expect(session.ip_address).to eq("127.0.0.1")
    end

    it "rejects a wrong password and does not create a session" do
      expect {
        post session_path, params: { email_address: user.email_address, password: "wrong" }
      }.not_to change(Session, :count)

      expect(response).to redirect_to(new_session_path)
      follow_redirect!
      expect(response.body).to include("Try another email address or password")
    end
  end

  describe "DELETE /session" do
    it "signs the person out and revokes the session" do
      post session_path, params: { email_address: user.email_address, password: "password" }
      expect(Session.count).to eq(1)

      expect { delete session_path }.to change(Session, :count).by(-1)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(new_session_path)
    end
  end
end
