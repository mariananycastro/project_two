# frozen_string_literal: true

module Types
  class QueryType < GraphQL::Schema::Object
    field :policy_query,            resolver: Resolvers::PolicyResolver,          null: true
    field :policies_query,          resolver: Resolvers::PoliciesResolver,        null: true
    field :policies_by_email_query, resolver: Resolvers::PoliciesByEmailResolver, null: true
  end
end
