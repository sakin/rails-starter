# frozen_string_literal: true

# Sends password reset instructions. Reference usage of the notification layer
# matching WelcomeNotification: produced by the password-reset flow and
# delivered through the unified layer — email is the default channel.
class PasswordResetNotification < ApplicationNotification
  def initialize(user:)
    @user = user
  end

  def deliver
    PasswordsMailer.reset(@user).deliver_later
  end
end
