# frozen_string_literal: true

# Preview the welcome email's rendered HTML in Lookbook (see /lookbook),
# via a component that isolates the generated body in an iframe.
class Mailer::Preview < ApplicationViewComponentPreview
  def welcome
    user = User.new(email_address: "hello@example.com")
    html = NotificationsMailer.welcome(user).message.html_part.body.decoded

    render Mailer::Component.new(subject: "Welcome", html: html)
  end
end
