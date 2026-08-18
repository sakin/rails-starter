# frozen_string_literal: true

require "stackprof"

# Test-suite profiler helper. Capture a CPU profile of a block, write a dump to
# tmp/profile_<label>.dump, and return the report. Read a dumped run back later
# with `stackprof tmp/profile_<label>.dump`.
module Profiler
  DEFAULT_DIR = Rails.root.join("tmp")

  module_function

  # Runs the block under a CPU profiler, writes tmp/profile_<label>.dump, and
  # returns the resulting StackProf::Report.
  def profile(label)
    dir = DEFAULT_DIR
    Dir.mkdir(dir) unless Dir.exist?(dir)
    path = dir.join("profile_#{label}.dump")
    StackProf.run(mode: :cpu, interval: 1000, out: path.to_s) { yield }
    StackProf::Report.new(Marshal.load(File.binread(path)))
  end
end
