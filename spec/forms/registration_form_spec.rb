# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationForm, type: :form do
  describe "validation" do
    it "is valid and persists a user with a valid email and password" do
      form = RegistrationForm.new(email_address: "sara@example.com", password: "password")

      expect { form.save }.to change(User, :count).by(1)

      user = User.find_by(email_address: "sara@example.com")
      expect(user).to be_present
      expect(user.authenticate("password")).to eq(user)
    end

    it "normalizes the email before persisting" do
      form = RegistrationForm.new(email_address: "  Sara@Example.com ", password: "password")

      form.save

      expect(User.find_by(email_address: "sara@example.com")).to be_present
    end

    it "is invalid and saves nothing when the email is blank" do
      form = RegistrationForm.new(email_address: "", password: "password")

      expect { form.save }.not_to change(User, :count)

      expect(form.save).to be(false)
      expect(form.errors[:email_address]).to be_present
    end

    it "is invalid when the email is already taken" do
      create(:user, email_address: "taken@example.com")
      form = RegistrationForm.new(email_address: "taken@example.com", password: "password")

      expect { form.save }.not_to change(User, :count)

      expect(form.save).to be(false)
      expect(form.errors[:email_address]).to be_present
    end

    it "is invalid and saves nothing when the password is blank" do
      form = RegistrationForm.new(email_address: "sara@example.com", password: "")

      expect { form.save }.not_to change(User, :count)

      expect(form.save).to be(false)
      expect(form.errors[:password]).to be_present
    end

    it "never persists a partial user on failure (no state drift)" do
      form = RegistrationForm.new(email_address: "", password: "")

      form.save

      expect(User.exists?(email_address: "")).to be(false)
      expect(form.email_address).to eq("")
      expect(form.errors).to be_any
    end
  end

  describe "#user" do
    it "exposes the built user ready for signing in" do
      form = RegistrationForm.new(email_address: "sara@example.com", password: "password")

      expect(form.user).to be_a(User)
      expect(form.user).not_to be_persisted
    end
  end
end
