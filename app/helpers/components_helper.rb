# frozen_string_literal: true

# View helper to render ViewComponents by name, so views and components don't
# hard-code a class reference everywhere.
#
# Absolute path:
#   <%= component "banner", title: "Hi" %>
#   <%= component "banner/badge", label: "New" %>
#
# Relative path (inside a component, resolved under the enclosing namespace):
#   <%= component ".badge", label: "New" %>   # inside Banner::Component → Banner::Badge
module ComponentsHelper
  # Render a component by name. `name` is a path like "banner" or "banner/badge",
  # or a relative ".badge" resolved against the enclosing component.
  def component(name, **args, &block)
    render component_class_for(name).new(**args), &block
  end

  private

  def component_class_for(name)
    klass =
      if name.to_s.start_with?(".")
        relative_component_class(name.to_s.delete_prefix("."))
      else
        absolute_component_class(name.to_s)
      end

    klass.constantize
  end

  def absolute_component_class(name)
    "#{name.split('/').map(&:camelize).join('::')}::Component"
  end

  # Resolve a relative name from the enclosing component's namespace. Within a
  # component this is the parent component's module, e.g. `Banner` for
  # `Banner::Component`.
  def relative_component_class(name)
    base = self.class.name.to_s.sub(/::Component\z/, "")
    "#{base}::#{name.split('/').map(&:camelize).join('::')}::Component"
  end
end
