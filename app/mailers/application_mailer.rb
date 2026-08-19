class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  # Mailer views live under app/views/mailers/<mailer>_mailer/ (PRD §3); the
  # default root (app/views) still finds the mailer layouts. Matches the
  # generator overrides (lib/generators/erb) so mail views are not left under
  # the default app/views/<mailer>_mailer/ location.
  append_view_path Rails.root.join("app/views/mailers")
end
