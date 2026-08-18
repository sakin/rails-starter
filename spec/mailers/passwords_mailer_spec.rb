# frozen_string_literal: true

require "rails_helper"

RSpec.describe PasswordsMailer, type: :mailer do
  describe "#reset" do
    subject(:mail) { described_class.reset(user) }

    let(:user) { create(:user) }

    it "delivers a reset-email to the user's address" do
      expect(mail.to).to eq([ user.email_address ])
      expect(mail.subject).to eq("Reset your password")
      expect(mail.from).to eq([ "from@example.com" ])
    end

    it "links to the password reset page with a signed token" do
      expect(mail.html_part.body.to_s).to match(%r{/passwords/[^"\s]+/edit})
    end
  end
end
