# frozen_string_literal: true

require "rails_helper"
require "yaml"

RSpec.describe Litestream do
  # The full set of replica env vars that switches replication on. Absent or
  # partial, the app must run unchanged (default-off).
  REPLICA_ENV = {
    "RAILS_ENV" => "production",
    "LITESTREAM_BUCKET" => "my-bucket",
    "LITESTREAM_ACCESS_KEY_ID" => "AKIAEXAMPLE",
    "LITESTREAM_SECRET_ACCESS_KEY" => "secret",
    "LITESTREAM_REGION" => "us-east-1"
  }.freeze

  describe ".enabled?" do
    it "is false when no replica env vars are present" do
      expect(described_class.enabled?({})).to be(false)
    end

    it "is true when all replica vars are present" do
      expect(described_class.enabled?(REPLICA_ENV)).to be(true)
    end

    it "is false when any single replica var is missing" do
      REPLICA_ENV.each_key do |key|
        expect(described_class.enabled?(REPLICA_ENV.without(key))).to be(false)
      end
    end

    it "is false when a replica var is present but blank" do
      env = REPLICA_ENV.merge("LITESTREAM_BUCKET" => "")
      expect(described_class.enabled?(env)).to be(false)
    end

    it "never replicates in development or test" do
      [ "development", "test" ].each do |env_name|
        env = REPLICA_ENV.merge("RAILS_ENV" => env_name)
        expect(described_class.enabled?(env)).to be(false)
      end
    end
  end

  describe ".options_from_env" do
    it "maps each replica env var to the matching S3 config option" do
      expect(described_class.options_from_env(REPLICA_ENV)).to eq(
        bucket: "my-bucket",
        access_key_id: "AKIAEXAMPLE",
        secret_access_key: "secret",
        region: "us-east-1"
      )
    end
  end

  describe ".yaml" do
    def render(**overrides)
      described_class.yaml(
        bucket: "my-bucket",
        access_key_id: "AKIAEXAMPLE",
        secret_access_key: "secret",
        region: "us-east-1",
        **overrides
      )
    end

    it "targets only the primary production database" do
      parsed = YAML.safe_load(render)
      expect(parsed["dbs"].map { |db| db["path"] }).to eq([ "storage/production.sqlite3" ])
    end

    it "never references the cache, queue, or cable databases" do
      yaml = render
      expect(yaml).not_to include("cache")
      expect(yaml).not_to include("queue")
      expect(yaml).not_to include("cable")
    end

    it "renders the S3 replica details" do
      replica = YAML.safe_load(render)["dbs"][0]["replicas"][0]
      expect(replica["type"]).to eq("s3")
      expect(replica["bucket"]).to eq("my-bucket")
      expect(replica["region"]).to eq("us-east-1")
      expect(replica["access-key-id"]).to eq("AKIAEXAMPLE")
      expect(replica["secret-access-key"]).to eq("secret")
    end

    it "omits the endpoint key unless one is supplied" do
      expect(render).not_to include("endpoint")
      with_endpoint = render(endpoint: "https://minio.example.com")
      expect(YAML.safe_load(with_endpoint)["dbs"][0]["replicas"][0]["endpoint"]).to eq(
        "https://minio.example.com"
      )
    end

    it "accepts an explicit primary db path" do
      parsed = YAML.safe_load(render(db_path: "storage/other.sqlite3"))
      expect(parsed["dbs"][0]["path"]).to eq("storage/other.sqlite3")
    end
  end
end
