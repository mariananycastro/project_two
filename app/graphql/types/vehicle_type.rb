# frozen_string_literal: true

module Types
  class VehicleType < GraphQL::Schema::Object
    description 'Vehicle'

    field :id,              ID,       null: false
    field :brand,           String,   null: false
    field :vehicle_model,   String,   null: false
    field :year,            Integer,  null: false
    field :license_plate,   String,   null: false
  end
end