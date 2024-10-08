# frozen_string_literal: true

module Types
  class PolicyType < GraphQL::Schema::Object
    description 'Policy'

    field :effective_from,    String,                       null: true
    field :effective_until,   String,                       null: true
    field :status,            PolicyStatusEnum,             null: true
    field :insured_person,    Types::InsuredPersonType,     null: true
    field :vehicle,           Types::VehicleType,           null: true
    field :payment,           Types::PaymentType,           null: true
  end
end
