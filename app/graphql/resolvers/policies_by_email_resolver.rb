module Resolvers
  class PoliciesByEmailResolver < GraphQL::Schema::Resolver
    description "Get a policies by user email"

    type [Types::PolicyType], null: true
    argument :email, String, required: true
    
    def resolve(email:)
      uri = URI("#{ENV['APP_ONE_PATH']}/insured_person/#{email}")
      response = Net::HTTP.get_response(uri.host, uri.path, uri.port)

      response.body.empty? ? [] : JSON.parse(response.body)
    end
  end
end
