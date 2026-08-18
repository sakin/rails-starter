# frozen_string_literal: true

require "net/http"

# The suite is wired to be HTTP-stub-friendly: WebMock blocks any outbound call
# that wasn't explicitly stubbed, and stubbed requests never touch the network.
RSpec.describe "HTTP stubbing" do
  it "blocks unstubbed outbound HTTP" do
    expect do
      Net::HTTP.get(URI("https://api.example.com/not-stubbed"))
    end.to raise_error(WebMock::NetConnectNotAllowedError)
  end

  it "serves a stubbed response without any real connection" do
    stub_request(:get, "https://api.example.com/things").to_return(body: "stubbed", status: 200)

    response = Net::HTTP.get(URI("https://api.example.com/things"))

    expect(response).to eq("stubbed")
    expect(WebMock).to have_requested(:get, "https://api.example.com/things")
  end
end
