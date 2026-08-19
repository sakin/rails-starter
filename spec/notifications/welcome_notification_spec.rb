# frozen_string_literal: true

require "rails_helper"

RSpec.describe WelcomeNotification, type: :notification do
  let(:user) { create(:user) }

  describe ".deliver" do
    it "queues a welcome email through the unified delivery layer" do
      expect {
        described_class.deliver(user: user)
      }.to have_enqueued_mail(NotificationsMailer, :welcome).with(user)
    end
  end

  describe "#deliver" do
    it "delegates to the email channel as the default delivery" do
      expect {
        described_class.new(user: user).deliver
      }.to have_enqueued_mail(NotificationsMailer, :welcome).with(user)
    end
  end
end
