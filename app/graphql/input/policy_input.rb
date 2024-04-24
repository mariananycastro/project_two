# frozen_string_literal: true

module Input
  class PolicyInput < GraphQL::Schema::InputObject
    argument :effective_from,   String,               required: true
    argument :effective_until,  String,               required: true
    argument :insured_person,   InsuredPersonInput,   required: true
    argument :vehicle,          VehicleInput,         required: true
  end
end
