# frozen_string_literal: true

RSpec.describe(DbQueryGuard, type: :component) do
  # A component that reaches into the database while rendering.
  class GuardedQueryComponent < ApplicationViewComponent
    def call
      "count=#{ActiveRecord::Base.connection.exec_query("SELECT 1 AS one").rows}"
    end
  end

  # A component that deliberately opts out of the guard.
  class AllowedQueryComponent < ApplicationViewComponent
    allow_db_queries!

    def call
      "count=#{ActiveRecord::Base.connection.exec_query("SELECT 1 AS one").rows}"
    end
  end

  it "raises loudly when a component fires a database query while rendering" do
    expect { render_inline(GuardedQueryComponent.new) }
      .to raise_error(DbQueryGuard::UncheckedQueryError, /database queries/)
  end

  it "allows data access when the component opts out" do
    expect(render_inline(AllowedQueryComponent.new)).to have_text(/\d+/)
  end
end
