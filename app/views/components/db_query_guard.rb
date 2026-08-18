# frozen_string_literal: true

# Fails loudly if a component fires database queries while it renders, unless
# the component opts out with `self.allow_db_queries = true`. Keeps data access
# out of the view layer by default and catches accidental N+1s at the source.
module DbQueryGuard
  extend ActiveSupport::Concern

  # Query notifications Active Record reports as bookkeeping rather than real
  # data reads.
  IGNORED_NAMES = [ "SCHEMA", "Active Record" ].freeze
  CONTROL_STATEMENTS = /\A(?:BEGIN|COMMIT|ROLLBACK|SAVEPOINT|RELEASE SAVEPOINT|SET |PRAGMA |VACUUM )/i

  class UncheckedQueryError < StandardError
    def initialize(component_class)
      super(
        "#{component_class} fired database queries while rendering. " \
          "Components should stay free of data access. If this is deliberate, " \
          "opt the component out with `self.allow_db_queries = true`."
      )
    end
  end

  included do
    # Opt a component into data access during rendering:
    #   self.allow_db_queries = true
    # The guard stays on by default for every other component.
    class_attribute :allow_db_queries, default: false
  end

  def render_in(view_context, ...)
    return super if self.class.allow_db_queries

    queries = []
    listener = lambda do |_name, _started, _finished, _id, payload|
      queries << payload[:sql].to_s if DbQueryGuard.query?(payload)
    end

    rendered = ActiveSupport::Notifications.subscribed(listener, "sql.active_record") do
      super
    end

    raise UncheckedQueryError, self.class if queries.any?

    rendered
  end

  class << self
    def query?(payload)
      sql = payload[:sql].to_s.strip
      return false if payload[:name].to_s.in?(IGNORED_NAMES)
      return false if sql.empty?
      return false if sql.match?(CONTROL_STATEMENTS)

      true
    end
  end
end
