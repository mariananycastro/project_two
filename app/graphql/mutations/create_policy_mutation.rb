# frozen_string_literal: true

module Mutations
  class CreatePolicyMutation < GraphQL::Schema::Mutation
    field :response, Types::ResponseType, null: false

    argument :policy, Input::PolicyInput, required: true

    def resolve(policy:)
      queue_name = 'create-policy'
      publish_message = BunnyConnectionService.publish_message(queue_name, policy)

      if publish_message
        { response: { status: 200, errors: [] } }
      else
        { response: { status: 422, errors: ['Connection Failed'] } }
      end
    rescue StandardError => exception
      { response: { status: 422, errors: [exception.message] } }
    end
  end
end
