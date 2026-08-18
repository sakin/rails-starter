# frozen_string_literal: true

# Reference for the N+1 guard (n_plus_one_control). It proves the matcher is
# wired and that it trips on a real N+1 query. The models and tables below are
# scaffolding local to this spec so the harness is demonstrated without adding
# any product models/schema (those arrive with the auth ticket).
module NPlusOneHarness
  class Author < ActiveRecord::Base
    self.table_name = "harness_authors"
    has_many :books, class_name: "NPlusOneHarness::Book", dependent: :destroy

    def self.populate(size)
      size.times do |i|
        author = create!(name: "Author #{i}")
        author.books.create!(title: "Book #{i}")
      end
    end
  end

  class Book < ActiveRecord::Base
    self.table_name = "harness_books"
    belongs_to :author, class_name: "NPlusOneHarness::Author"
  end
end

RSpec.describe "N+1 guard", type: :model, n_plus_one: true do
  before(:all) do
    connection = ActiveRecord::Base.connection
    unless connection.table_exists?("harness_authors")
      connection.create_table(:harness_authors, force: true) { |t| t.string :name }
      connection.create_table(:harness_books, force: true) do |t|
        t.integer :author_id
        t.string :title
      end
    end
  end

  after(:all) do
    NPlusOneHarness::Book.delete_all
    NPlusOneHarness::Author.delete_all
  end

  populate { |size| NPlusOneHarness::Author.populate(size) }

  it "is wired and trips on a real N+1 (per-row association queries)" do
    expect do
      expect { NPlusOneHarness::Author.all.each { |author| author.books.count } }
        .to perform_constant_number_of_queries
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "passes a constant query count without false positives" do
    expect { NPlusOneHarness::Author.all.to_a }.to perform_constant_number_of_queries
  end
end
