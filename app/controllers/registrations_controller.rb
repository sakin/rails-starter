class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_registration_path, alert: "Try again later." }

  def new
    @form = RegistrationForm.new
  end

  def create
    @form = RegistrationForm.new(registration_params)
    if @form.save
      start_new_session_for @form.user
      redirect_to root_path, notice: "Signed up successfully."
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def registration_params
      params.require(:registration).permit(:email_address, :password)
    end
end
