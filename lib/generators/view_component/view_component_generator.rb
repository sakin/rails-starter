# frozen_string_literal: true

# Generates a view component under the sidecar convention used across the app
# (modeled on the view_component-contrib generator, adapted for this repo).
#
#   rails generate view_component Banner
#   rails generate view_component Profile name age
#   rails generate view_component admin/sidebar title
#
# Each component is a folder under `app/views/components` holding `component.rb`,
# `component.html.erb`, `preview.rb` and `styles.css`, plus a component spec
# under `spec/views/components`. Sidecar styles are bundled by an entrypoint glob
# over `**/styles.css`, so no per-component JS shim is generated.
class ViewComponentGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :attributes, type: :array, default: [], banner: "attribute"

  def create_component_file
    template "component.rb.tt", File.join(components_dir, "component.rb")
  end

  def create_template_file
    template "component.html.erb.tt", File.join(components_dir, "component.html.erb")
  end

  def create_preview_file
    template "preview.rb.tt", File.join(components_dir, "preview.rb")
  end

  def create_styles_file
    template "styles.css.tt", File.join(components_dir, "styles.css")
  end

  def create_component_spec
    template "component_spec.rb.tt", File.join(spec_dir, "#{singular_name}_component_spec.rb")
  end

  private

  def components_dir
    "app/views/components/#{file_path}"
  end

  # Specs live flat under `spec/views/components` (mirroring the canonical
  # convention rather than one folder per component).
  def spec_dir
    "spec/views/components"
  end

  # `banner` / `admin--sidebar` — the scoped CSS token in `class_for("root")`.
  def component_class_token
    @component_class_token ||= class_name.underscore.gsub("/", "--")
  end

  # Ruby keyword arguments used to construct the component in generated preview
  # and spec, e.g. `title: "title", age: "age"` (or empty). `attributes` are
  # `Rails::Generators::GeneratedAttribute` objects, so use their `.name`.
  def example_options
    return "" if attributes.none?

    attributes.map { |attr| "#{attr.name}:\"#{attr.name}\"" }.join(", ")
  end

  # A dry-types coercion suffix for a declared attribute type, so generated
  # boolean/integer options coerce values at the boundary (e.g. `age:integer`
  # -> `type: Dry::Types["params.integer"]`). Attribute types that need no
  # coercion (strings, untyped args) get a bare `option :name`.
  def dry_type_suffix(attr)
    type = {
      boolean: "params.bool",
      integer: "params.integer"
    }[attr.type]

    type ? ", type: Dry::Types[\"#{type}\"]" : ""
  end
end
