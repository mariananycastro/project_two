# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeController,
 type: :controller do
  subject(:webhook_request) do
    post :webhook
  end

  context 'when payload is invalid' do
    context 'when payload does not have data and object keys' do
      it 'returns bad request' do
        subject

        expect(response.status).to eq(400)
        expect(response.body).to eq('')
      end
    end
  end

  context 'with valid payload' do
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
        type: "#{ event_type }"
      }
    end

    context 'when is listened event' do
      let(:event_type) { 'checkout.session.completed' }
      let(:event) { Stripe::Event.construct_from(event_data) }

      before do
        allow(request).to receive(:body).and_return('valid_payload')
        allow(Stripe::Webhook)
          .to receive(:construct_event)
          .and_return(event)
      end

      it 'calls UpdateStripePaymentService' do
        expect(UpdateStripePaymentService).to receive(:execute)

        subject
      end

      context 'when update paymente fails' do
        it 'calls UpdateStripePaymentService' do
          allow(UpdateStripePaymentService).to receive(:execute).and_return(false)

          subject

          expect(response.status).to eq 400
        end
      end

      context 'when update payment successed' do
        it 'calls UpdateStripePaymentService' do
          allow(UpdateStripePaymentService).to receive(:execute).and_return(true)

          subject

          expect(response.status).to eq 200
        end
      end
    end

    context 'when event is not listened' do
      let(:event_type) { 'random.event' }

      it 'does NOT call UpdateStripePaymentService' do
        expect(UpdateStripePaymentService).not_to receive(:execute)

        subject
      end

      it 'return bad request' do
        subject

        expect(response.status).to eq 400
      end
    end
  end
end
