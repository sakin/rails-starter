# frozen_string_literal: true

# Mailer behind the notification layer's default (email) channel.
class NotificationsMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail subject: "Welcome", to: user.email_address
  end
end
