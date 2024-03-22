# frozen_string_literal: true

module Types
  class PolicyType < GraphQL::Schema::Object
    description 'Policy'

    field :id,                ID,                       null: false
    field :effective_from,    String,                   null: false
    field :effective_until,   String,                   null: false
    field :insured_person,    Types::InsuredPersonType, null: false
    field :vehicle,           Types::VehicleType,       null: false
  end
end
