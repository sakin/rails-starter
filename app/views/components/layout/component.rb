# frozen_string_literal: true

# Default application layout assembled from the shared UI primitives. Renders
# the full HTML document: every page gets the nav and the flash region, and the
# page's own markup is yielded as the main content. Kept DB-free (no queries);
# auth state is read from `Current`, already resolved in the controller layer.
class Layout::Component < ApplicationViewComponent
  option :title, default: -> { "Rails Starter" }
  option :head, default: -> { "" }
  option :application_name, default: -> { "Rails Starter" }
end
