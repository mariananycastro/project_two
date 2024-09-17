# frozen_string_literal: true

module Types
  class PaymentType < GraphQL::Schema::Object
    description 'Payment'

    field :status,           PaymentStatusEnum,   null: false
    field :link,             String,              null: false
    field :price,            Float,               null: false
  end
end
