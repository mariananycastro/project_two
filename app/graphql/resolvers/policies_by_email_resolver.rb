module Resolvers
  class PoliciesByEmailResolver < GraphQL::Schema::Resolver
    description "Get a policies by user email"

    type [Types::PolicyType], null: true
    argument :email, String, required: true

    def resolve(email:)
      path = "insured_person/#{email}"
      response = Clients::AppOneClient.execute(path)

      response.body.empty? ? [] : JSON.parse(response.body)
    end
  end
end
