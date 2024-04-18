# frozen_string_literal: true

module Resolvers
  class PolicyResolver < GraphQL::Schema::Resolver
    description "Get a policy by id"

    type Types::PolicyType, null: true
    argument :id, ID, required: true

    def resolve(id:)
      uri = URI("#{ENV['APP_ONE_PATH']}/policies/#{id}")
      response = Net::HTTP.get_response(uri.host, uri.path, uri.port)

      response.body.empty? ? {} : JSON.parse(response.body)
    end
  end
end
