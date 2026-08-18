# frozen_string_literal: true

# Fails loudly if a component fires database queries while it renders, unless
# the component opts out with `self.allow_db_queries = true`. Keeps data access
# out of the view layer by default and catches accidental N+1s at the source.
#
# Queries are attributed to the component that is *innermost* at the moment the
# query fires, so a guarded parent does not punish a nested component that opted
# out — the opt-out is honored on the component that actually queries, regardless
# of how deeply it is nested.
module DbQueryGuard
  extend ActiveSupport::Concern

  # Key on Thread.current for the stack of components currently mid-render.
  THREAD_STACK_KEY = :_view_component_db_query_stack

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
    stack = (Thread.current[THREAD_STACK_KEY] ||= [])
    stack << self.class

    queries = []
    listener = lambda do |_name, _started, _finished, _id, payload|
      # Only a query fired while this component is the innermost render is its
      # responsibility; a nested component rendering deeper owns its own queries.
      queries << payload[:sql].to_s if stack.last == self.class && DbQueryGuard.query?(payload)
    end

    rendered = ActiveSupport::Notifications.subscribed(listener, "sql.active_record") do
      super
    end

    raise UncheckedQueryError, self.class if queries.any? && !self.class.allow_db_queries

    rendered
  ensure
    stack&.pop
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
