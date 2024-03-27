# frozen_string_literal: true

module Types
  class ResponseType < GraphQL::Schema::Object
    description 'Default response'

    field :status,    Int,        null: false,    description: "Policy creation status response"
    field :errors,    [String],   null: false,    description: "Policy creation errors"
  end
end
