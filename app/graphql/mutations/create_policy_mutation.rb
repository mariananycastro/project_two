# frozen_string_literal: true

module Mutations
  class CreatePolicyMutation < GraphQL::Schema::Mutation
    field :response,    Int,   null: false,    description: "Policy creation status response"

    argument :policy, Input::PolicyInput, required: true

    def resolve(policy:)
      queue_name = 'create-policy'
      publish_message = BunnyConnectionService.publish_message(queue_name, policy)

      { response: 200 }
    end
  end
end
