# frozen_string_literal: true

module Input
  class InsuredPersonInput < GraphQL::Schema::InputObject
    argument :name,       String,    required: true
    argument :document,   String,    required: true
  end
end
