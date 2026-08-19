# frozen_string_literal: true

# Renders a mailer's generated HTML body inside an isolated iframe so
# component/mailer work can be previewed in Lookbook. Previews live in the
# same sidecar folder.
class Mailer::Component < ApplicationViewComponent
  option :subject
  option :html
end
