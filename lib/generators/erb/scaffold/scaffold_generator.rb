# frozen_string_literal: true

require "rails/generators/erb/scaffold/scaffold_generator"

# Generates scaffold views/partials under app/views/controllers/<controller>/
# (PRD §3), matching ApplicationController's append_view_path.
class Erb::Generators::ScaffoldGenerator
  def create_root_folder
    empty_directory File.join("app/views/controllers", controller_file_path)
  end

  def copy_view_files
    available_views.each do |view|
      formats.each do |format|
        filename = filename_with_extensions(view, format)
        template filename, File.join("app/views/controllers", controller_file_path, filename)
      end
    end

    template "partial.html.erb", File.join("app/views/controllers", controller_file_path, "_#{singular_name}.html.erb")
  end
end
