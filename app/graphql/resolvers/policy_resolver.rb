# frozen_string_literal: true

module Resolvers
  class PolicyResolver < GraphQL::Schema::Resolver
    description "Get a policy by id"

    type Types::PolicyType, null: true
    argument :id, ID, required: true

    def resolve(id:)
      path = "policies/#{id}"
      response = Clients::AppOneClient.execute(path)

      response.body.empty? ? {} : JSON.parse(response.body)
    end
  end
end
