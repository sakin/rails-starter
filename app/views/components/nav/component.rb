# frozen_string_literal: true

# Shared top navigation. Renders auth-aware links from the already-resolved
# `Current.session` (set in the controller layer) so it stays DB-free while
# rendering, and hosts the light/dark theme toggle.
class Nav::Component < ApplicationViewComponent
  def signed_in?
    Current.session.present?
  end

  def application_name
    "Rails Starter"
  end
end
