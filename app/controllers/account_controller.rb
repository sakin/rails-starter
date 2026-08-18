# Minimal protected reference page demonstrating the auth layer: guests are
# steered to sign-in and a signed-in person is recognized from their session.
# Keep thin — the visible lookup/signing live in the layout (ticket 06).
class AccountController < ApplicationController
  def show
  end
end
