# frozen_string_literal: true

require "rails/generators/rails/authentication/authentication_generator"

# Redirects the authentication generator's password-reset MAILER views to
# app/views/mailers/ (PRD §3), matching ApplicationMailer's append_view_path.
#
# This mirrors the Railties implementation of as of 8.1.3.1, changing only the
# two mailer view destinations; the session/password CONTROLLER views are
# redirected by the erb:authentication override (lib/generators/erb/authentication/).
class Rails::Generators::AuthenticationGenerator
  def create_authentication_files
    template "app/models/session.rb"
    template "app/models/user.rb"
    template "app/models/current.rb"

    template "app/controllers/sessions_controller.rb"
    template "app/controllers/concerns/authentication.rb"
    template "app/controllers/passwords_controller.rb"

    template "app/channels/application_cable/connection.rb" if defined?(ActionCable::Engine)

    if defined?(ActionMailer::Railtie)
      template "app/mailers/passwords_mailer.rb"

      template "app/views/passwords_mailer/reset.html.erb", "app/views/mailers/passwords_mailer/reset.html.erb"
      template "app/views/passwords_mailer/reset.text.erb", "app/views/mailers/passwords_mailer/reset.text.erb"
    end
  end
end
