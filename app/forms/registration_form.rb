# frozen_string_literal: true

# Purpose-built form object for creating an account. The reference usage of the
# UI-forms layer: the controller drives a form object instead of mutating a
# model directly, and success/failure is expressed through the form's own
# validity and errors.
class RegistrationForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email_address, :string
  attribute :password, :string

  validate :validate_user

  def save
    return false unless valid?

    user.save!
    true
  end

  def user
    @user ||= User.new(email_address: email_address, password: password)
  end

  private

  def validate_user
    user.valid?
    user.errors.each { |error| errors.add(error.attribute, error.type) }
  end
end
