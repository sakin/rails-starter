# frozen_string_literal: true

RSpec.describe(DbQueryGuard, type: :view_component) do
  # A component that reaches into the database while rendering.
  class GuardedQueryComponent < ApplicationViewComponent
    def call
      "count=#{ActiveRecord::Base.connection.exec_query("SELECT 1 AS one").rows}"
    end
  end

  # A component that deliberately opts out of the guard with the PRD-recommended
  # `self.allow_db_queries = true` form.
  class AllowedQueryComponent < ApplicationViewComponent
    self.allow_db_queries = true

    def call
      "count=#{ActiveRecord::Base.connection.exec_query("SELECT 1 AS one").rows}"
    end
  end

  it "raises loudly when a component fires a database query while rendering" do
    expect { render_inline(GuardedQueryComponent.new) }
      .to raise_error(DbQueryGuard::UncheckedQueryError, /database queries/)
  end

  it "does not raise when the component opts out with self.allow_db_queries = true" do
    expect(render_inline(AllowedQueryComponent.new)).to have_text(/\d+/)
  end
end
