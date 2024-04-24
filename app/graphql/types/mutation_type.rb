# frozen_string_literal: true

module Types
  class MutationType < GraphQL::Schema::Object
    field :create_policy, mutation: Mutations::CreatePolicyMutation
  end
end
