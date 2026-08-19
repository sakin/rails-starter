# frozen_string_literal: true

# Welcomes a newly created account. Reference usage of the notification layer:
# produced by the registration flow and delivered through the unified layer —
# email is the default (and currently only) channel.
class WelcomeNotification < ApplicationNotification
  def initialize(user:)
    @user = user
  end

  def deliver
    NotificationsMailer.welcome(@user).deliver_later
  end
end
