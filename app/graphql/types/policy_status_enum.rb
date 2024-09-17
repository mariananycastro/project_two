module Types
  class PolicyStatusEnum < GraphQL::Schema::Enum
    description 'Policy status options'

    value 'draft',          'Policy is draft'
    value 'active',         'Policy is active'
    value 'expired',        'Policy is expired'
    value 'canceled',       'Policy is canceled'
    value 'pending',        'Policy is pending'
  end
end
