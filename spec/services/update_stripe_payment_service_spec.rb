# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateStripePaymentService do
  subject(:service) { described_class.execute(payload) }

  context 'calls BunnyConnectionService' do
    let(:event_data) do
      {
        id: 'evt_1PC53nCT1rSKEpFZmebP2d9s',
        data: {
          object: {
            id:'cs_test_a1CprekT1s',
            object:'checkout.session',
            payment_status:'paid',
            status:'complete',
            success_url:'http://localhost:3000/success_payment',
            url:'link_url'
          }
        },
        type: 'checkout.session.completed'
      }
    end
    let(:payload) { Stripe::Event.construct_from(event_data) }
    let(:queue_name) { 'update-payment' }

    it 'with queue update-payment' do
      expect(BunnyConnectionService)
        .to receive(:publish_message)
        .with(queue_name, payload)

        subject
    end
  end
end
