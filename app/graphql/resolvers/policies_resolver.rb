# frozen_string_literal: true

module Resolvers
  class PoliciesResolver < GraphQL::Schema::Resolver
    description "Get a policies"

    type [Types::PolicyType], null: true
    
    def resolve
      uri = URI("#{ENV['APP_ONE_PATH']}/policies/")
      response = Net::HTTP.get_response(uri.host, uri.path, uri.port)
      JSON.parse(response.body)
    end
  end
end
