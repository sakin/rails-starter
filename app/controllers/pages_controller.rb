# Minimal public landing page used as the themed surface until the real layout
# lands (see issue 06). Frontend-swap reference page.
class PagesController < ApplicationController
  allow_unauthenticated_access

  def home
  end
end
