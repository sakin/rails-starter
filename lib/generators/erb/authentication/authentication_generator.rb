# frozen_string_literal: true

require "rails/generators/erb/authentication/authentication_generator"

# Generates the authentication generator's session/password controller views
# under app/views/controllers/ (PRD §3), matching ApplicationController's
# append_view_path. The companion password-reset mailer views are redirected by
# the rails:authentication override (lib/generators/rails/authentication/).
class Erb::Generators::AuthenticationGenerator
  def create_files
    template "app/views/passwords/new.html.erb", File.join("app/views/controllers/passwords/new.html.erb")
    template "app/views/passwords/edit.html.erb", File.join("app/views/controllers/passwords/edit.html.erb")
    template "app/views/sessions/new.html.erb", File.join("app/views/controllers/sessions/new.html.erb")
  end
end
