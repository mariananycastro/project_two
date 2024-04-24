# frozen_string_literal: true

module Types
  class InsuredPersonType < GraphQL::Schema::Object
    description 'Insure Person'

    field :id,         ID,      null: false
    field :name,       String,  null: false
    field :document,   String,  null: false
    field :email,      String,  null: false
  end
end
