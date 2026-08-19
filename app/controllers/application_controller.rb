class ApplicationController < ActionController::Base
  include Authentication
  rescue_from ApplicationPolicy::NotAuthorizedError, with: :forbidden
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private
    # Authorize the current action against the given policy class, dispatching
    # to the predicate matching the controller action (`show?`, `update?`, ...).
    # Returns the record on success; raises (rescued as 403) on denial.
    def authorize(record, with:)
      policy = with.new(user: Current.user, record: record)
      raise ApplicationPolicy::NotAuthorizedError unless policy.public_send("#{action_name}?")

      record
    end

    def forbidden
      render "errors/forbidden", status: :forbidden
    end
end
