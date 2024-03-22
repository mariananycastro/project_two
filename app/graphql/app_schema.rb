# frozen_string_literal: true

class AppSchema < GraphQL::Schema
  # mutation(Types::MutationType) 
  query(Types::QueryType)
end
