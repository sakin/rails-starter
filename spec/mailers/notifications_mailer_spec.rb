# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  describe "#welcome" do
    subject(:mail) { described_class.welcome(user) }

    let(:user) { create(:user) }

    it "delivers a welcome email to the person's address" do
      expect(mail.to).to eq([ user.email_address ])
      expect(mail.from).to eq([ "from@example.com" ])
    end

    it "carries a welcoming subject" do
      expect(mail.subject).to eq("Welcome")
    end

    it "greets the person by name in the body" do
      expect(mail.html_part.body.to_s).to include(user.email_address)
      expect(mail.text_part.body.to_s).to include(user.email_address)
    end
  end
end
