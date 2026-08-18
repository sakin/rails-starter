# frozen_string_literal: true

# Generates a view component under the sidecar convention used across the app.
#
#   rails generate view_component Banner
#   rails generate view_component admin/sidebar
#
# Each component is a folder under `app/frontend/components` holding
# `component.rb`, `component.html.erb`, `preview.rb` and `index.css`.
class ViewComponentGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  argument :name, type: :string, banner: "NAME"

  def create_component
    @component = name.underscore
    @component_constant = @component.split("/").map(&:camelize).join("::")
    @class_token = @component.gsub("/", "--")

    empty_directory components_dir

    template "component.rb.tt",     "#{components_dir}/component.rb"
    template "component.html.erb.tt", "#{components_dir}/component.html.erb"
    template "preview.rb.tt",       "#{components_dir}/preview.rb"
    template "index.css.tt",        "#{components_dir}/index.css"
    template "index.js.tt",         "#{components_dir}/index.js"
  end

  private

  def components_dir
    "app/frontend/components/#{@component}"
  end
end
