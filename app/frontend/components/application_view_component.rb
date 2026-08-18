# frozen_string_literal: true

# Abstract base for every view component in the app. Never renders itself.
#
# `ViewComponentContrib::Base` already wires in:
#   - component-scoped i18n via `t(".key")` -> `en.view_components.<scope>`;
#   - the `#wrapped` helper for container wrappers.
# `DbQueryGuard` makes stray database queries raise during rendering.
class ApplicationViewComponent < ViewComponentContrib::Base
  include DbQueryGuard

  # Stimulus identifier for this component's controller: `Nav::UserInfo::Component`
  # -> `nav--user-info`.
  def controller_name
    @controller_name ||= self.class.name.sub("::Component", "").underscore.split("/").join("--")
  end

  # A scoped CSS class token so component styles never collide across folders.
  def class_for(token)
    "c-#{controller_name}-#{token}"
  end
end
