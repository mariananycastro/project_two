# frozen_string_literal: true

module Resolvers
  class PoliciesResolver < GraphQL::Schema::Resolver
    description "Get a policies"

    type [Types::PolicyType], null: true
    
    def resolve
      path = "policies/"
      response = Clients::AppOneClient.execute(path)

      response.body.empty? ? [] : JSON.parse(response.body)
    end
  end
end
