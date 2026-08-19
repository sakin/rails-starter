# frozen_string_literal: true

require "rename_to"

desc "Rename the starter's app name across config/debug surfaces (see RenameTo.help)"
task :rename_to, [ :app_name ] do |_t, args|
  app_name = args[:app_name].to_s.strip
  if app_name.empty? || %w[ -h --help ].include?(app_name)
    puts RenameTo.help
    next
  end

  files = RenameTo::TARGET_FILES.map { |rel| Rails.root.join(rel).to_s }
  report = RenameTo.apply!(files: files, app_name: app_name)

  puts "Renamed application to `#{app_name}`:"
  report.each do |path, changed|
    status = changed == :missing ? "missing" : changed.join(", ")
    puts format("  %-42s %s", Pathname(path).basename, status)
  end
end
