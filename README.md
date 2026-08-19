# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

  Optional continuous database backup (Litestream, OFF by default):
  supply the LITESTREAM_BUCKET / _ACCESS_KEY_ID / _SECRET_ACCESS_KEY /
  _REGION (and optional _ENDPOINT for S3-compatible services) env vars to the
  production container to continuously replicate the primary app database to S3.
  Without them the app runs unchanged and replicates nothing; local development
  and the test suite never replicate. Config is rendered at container start by
  bin/litestream_config; see lib/litestream.rb.

* ...
