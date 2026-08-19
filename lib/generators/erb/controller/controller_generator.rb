# frozen_string_literal: true

require "rails/generators/erb/controller/controller_generator"

# Generates controller views under app/views/controllers/<controller>/ (PRD §3),
# matching ApplicationController's append_view_path. Template content comes from
# Railties; only the base path differs.
class Erb::Generators::ControllerGenerator
  def copy_view_files
    base_path = File.join("app/views/controllers", class_path, file_name)
    empty_directory base_path

    actions.each do |action|
      @action = action
      formats.each do |format|
        @path = File.join(base_path, filename_with_extensions(action, format))
        template filename_with_extensions(:view, format), @path
      end
    end
  end
end
