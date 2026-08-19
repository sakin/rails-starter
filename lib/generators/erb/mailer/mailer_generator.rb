# frozen_string_literal: true

require "rails/generators/erb/mailer/mailer_generator"

# Generates mail views under app/views/mailers/<mailer>_mailer/ (PRD §3),
# matching ApplicationMailer's append_view_path. Mailer layouts still go to
# app/views/layouts, which the default view root resolves.
class Erb::Generators::MailerGenerator
  def copy_view_files
    view_base_path = File.join("app/views/mailers", class_path, file_name + "_mailer")
    empty_directory view_base_path

    if behavior == :invoke
      formats.each do |format|
        layout_path = File.join("app/views/layouts", class_path, filename_with_extensions("mailer", format))
        template filename_with_extensions(:layout, format), layout_path unless File.exist?(layout_path)
      end
    end

    actions.each do |action|
      @action = action

      formats.each do |format|
        @path = File.join(view_base_path, filename_with_extensions(action, format))
        template filename_with_extensions(:view, format), @path
      end
    end
  end
end
