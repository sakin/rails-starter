# frozen_string_literal: true

# Proves the stackprof-based profiler helper is in place and usable: it samples
# CPU time from a block into a report and a dump file under tmp/.
RSpec.describe "Profiler" do
  it "captures a stack profile from a block" do
    report = Profiler.profile("smoke") { 50_000.times { "x".upcase } }

    expect(File).to exist(Rails.root.join("tmp/profile_smoke.dump"))
    expect(report).to be_a(StackProf::Report)
    expect(report.files).not_to be_empty
  end
end
