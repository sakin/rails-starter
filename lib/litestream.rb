# frozen_string_literal: true

require "yaml"

# Optional, default-off continuous replication of the primary production
# SQLite database to an S3-compatible bucket via Litestream. The logic is a
# pure function of the environment and db paths so it can be tested without the
# binary or a network; bin/docker-entrypoint drives it against the container.
#
# By default (no replica env vars) the app runs exactly as before and nothing
# replicates. Replication only switches on once every variable in REPLICA_ENV is
# present and non-blank, and never in the development/test environments.
#
# The rendered config targets only the primary app database
# (storage/production.sqlite3) — the transient Solid cache/queue/cable databases
# are never replicated.
module Litestream
  DEFAULT_DB_PATH = "storage/production.sqlite3"

  # The environment variables that gate replication. All must be present and
  # non-blank for replication to activate.
  REPLICA_ENV = %w[
    LITESTREAM_BUCKET
    LITESTREAM_ACCESS_KEY_ID
    LITESTREAM_SECRET_ACCESS_KEY
    LITESTREAM_REGION
  ].freeze

  # Maps each replica env var to the corresponding S3 config option, so config
  # drivers can source their arguments from this single list.
  ENV_TO_OPTION = REPLICA_ENV.to_h do |var|
    [ var, var.sub("LITESTREAM_", "").downcase.to_sym ]
  end.freeze

  class << self
    # Returns true only when every replica var is set and the app is running in
    # production. Absent, partial, or blank vars (or dev/test) mean replication
    # stays off and the app behaves normally.
    def enabled?(env)
      production = env.fetch("RAILS_ENV", "development") == "production"
      production && REPLICA_ENV.all? { |key| !env[key].to_s.empty? }
    end

    # Returns the S3 option keywords derived from the replica env vars, suitable
    # for splatting into `.yaml`. Lets drivers pull from this single env-to-option
    # mapping instead of re-listing the var names.
    def options_from_env(env)
      ENV_TO_OPTION.each_with_object({}) do |(var, option), kwargs|
        kwargs[option] = env[var]
      end
    end

    # Renders a Litestream config that continuously replicates the single
    # primary DB path. An optional endpoint targets S3-compatible services such
    # as MinIO, Garage, or Cloudflare R2.
    def yaml(bucket:, access_key_id:, secret_access_key:, region:, db_path: DEFAULT_DB_PATH, endpoint: nil)
      replica = {
        "type" => "s3",
        "bucket" => bucket,
        "region" => region,
        "access-key-id" => access_key_id,
        "secret-access-key" => secret_access_key,
        "path" => db_path.sub(/\..*$/, "")
      }
      replica["endpoint"] = endpoint if endpoint && !endpoint.empty?

      { "dbs" => [ { "path" => db_path, "replicas" => [ replica ] } ] }.to_yaml
    end
  end
end
