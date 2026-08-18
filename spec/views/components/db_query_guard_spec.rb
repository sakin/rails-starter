# frozen_string_literal: true

RSpec.describe(DbQueryGuard, type: :view_component) do
  # Guards are scoped to the component that actually queries (the innermost one
  # rendering), so a guarded parent does not punish a nested component that opted
  # out. These run through the real render pipeline to exercise nesting.

  # A guarded component that reaches into the database while rendering.
  class GuardedQueryComponent < ApplicationViewComponent
    def call
      "count=#{ActiveRecord::Base.connection.exec_query("SELECT 1 AS one").rows}"
    end
  end

  # A guarded component that renders a nested, allowed querying component.
  class GuardedNestingParent < ApplicationViewComponent
    def call
      render AllowedQueryChild.new
    end
  end

  # A guarded component that renders a nested, guarded querying component.
  class GuardedNestingGuardedParent < ApplicationViewComponent
    def call
      render GuardedQueryChild.new
    end
  end

  class AllowedQueryChild < ApplicationViewComponent
    self.allow_db_queries = true

    def call
      "count=#{ActiveRecord::Base.connection.exec_query("SELECT 1 AS one").rows}"
    end
  end

  class GuardedQueryChild < ApplicationViewComponent
    def call
      "count=#{ActiveRecord::Base.connection.exec_query("SELECT 1 AS one").rows}"
    end
  end

  # PRD-recommended opt-out form on a top-level component.
  class AllowedQueryComponent < ApplicationViewComponent
    self.allow_db_queries = true

    def call
      "count=#{ActiveRecord::Base.connection.exec_query("SELECT 1 AS one").rows}"
    end
  end

  it "raises when a component fires a database query while rendering" do
    expect { render_inline(GuardedQueryComponent.new) }
      .to raise_error(DbQueryGuard::UncheckedQueryError, /database queries/)
  end

  it "does not raise when the component opts out with self.allow_db_queries = true" do
    expect(render_inline(AllowedQueryComponent.new)).to have_text(/\d+/)
  end

  it "honors a nested component's opt-out when a guarded parent drives the render" do
    expect(render_inline(GuardedNestingParent.new)).to have_text("count=[[1]]")
  end

  it "still raises when a nested component that has not opted out queries" do
    expect { render_inline(GuardedNestingGuardedParent.new) }
      .to raise_error(DbQueryGuard::UncheckedQueryError, /database queries/)
  end
end
