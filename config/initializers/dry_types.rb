# frozen_string_literal: true

# Load dry-types explicitly so view components can reference `Dry::Types[...]`
# in their `option :foo, type: Dry::Types[...]` declarations at class-definition
# time. dry-initializer does not require dry-types itself.
require "dry/types"
