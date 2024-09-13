module Types
  class PaymentStatusEnum < GraphQL::Schema::Enum
    description 'Payment status options'

    value 'pending',    'Payment is pending'
    value 'paid',       'Payment was paid'
    value 'failed',     'Payment has failed'
    value 'expired',    'Payment link is expired'
  end
end
