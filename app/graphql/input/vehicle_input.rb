# frozen_string_literal: true

module Input
  class VehicleInput < GraphQL::Schema::InputObject
    argument :brand,              String,    required: true
    argument :vehicle_model,      String,    required: true
    argument :year,               String,    required: true
    argument :license_plate,      String,    required: true
  end
end
