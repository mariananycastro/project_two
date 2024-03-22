# frozen_string_literal: true

module Types
  class QueryType < GraphQL::Schema::Object
    field :policy_query,    resolver: Resolvers::PolicyResolver,    null: true
  end
end
