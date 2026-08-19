# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it "is valid with a unique email and a password" do
    expect(user).to be_valid
  end

  it "normalizes the email to a stripped, lowercased value" do
    user.email_address = "  Foo@Example.COM "
    user.save!
    expect(user.reload.email_address).to eq("foo@example.com")
  end

  it "requires a unique email address" do
    create(:user, email_address: "taken@example.com")
    expect(build(:user, email_address: "taken@example.com")).not_to be_valid
  end

  describe "has_secure_password" do
    it "authenticates the correct password" do
      user.save!
      expect(User.authenticate_by(email_address: user.email_address, password: "password")).to eq(user)
    end

    it "rejects a wrong password" do
      user.save!
      expect(User.authenticate_by(email_address: user.email_address, password: "wrong")).to be_nil
    end
  end

  describe "password reset tokens" do
    it "issues a signed reset token tied to the current password" do
      user.save!
      token = user.password_reset_token
      expect(User.find_by_password_reset_token!(token)).to eq(user)
    end

    it "invalidates the token after the password changes" do
      user.save!
      token = user.password_reset_token
      user.update!(password: "newpassword")
      expect(User.find_by_password_reset_token(token)).to be_nil
    end

    it "exposes an expiry window" do
      expect(user.password_reset_token_expires_in).to be_a(Integer)
    end

    it "raises for an invalid token" do
      expect { User.find_by_password_reset_token!("bogus") }
        .to raise_error(ActiveSupport::MessageVerifier::InvalidSignature)
    end
  end

  describe "associations" do
    it "destroys its sessions with the user" do
      user.save!
      create(:session, user: user)
      expect { user.destroy }.to change(Session, :count).by(-1)
    end
  end

  describe "#revoke_all_sessions!" do
    it "destroys every session belonging to the user" do
      user.save!
      create_list(:session, 2, user: user)
      expect { user.revoke_all_sessions! }.to change(user.sessions, :count).to(0)
    end
  end
end
