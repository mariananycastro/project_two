# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::PoliciesResolver, type: :request do
  let(:headers) do
    expires_at = 10.hours.from_now
    jwt_token = JWT.encode({ exp: expires_at.to_i }, ENV['JWT_SECRET'], ENV['JWT_ALGORITHM'])

    {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{jwt_token}"
    }
  end
  subject(:graphql_request) do
    post '/graphql', params: { query: policies_query }.to_json, headers: headers
  end
  let(:policies_query) do
    <<-GRAPHQL
      query {
        policiesQuery {
          effectiveFrom
          effectiveUntil
          status
          insuredPerson {
            name
            email
            document
          }
          vehicle {
            brand
            vehicleModel
            year
            licensePlate
          }
          payment {
            status
            link
            price
          }
        }
      }
    GRAPHQL
  end

  context 'when policies exist' do
    let(:http_response) do
      [
        {
          effective_from: '2024-03-19',
          effective_until: '2025-03-19',
          status: 'draft',
          insured_person: {
            name: 'Maria Silva',
            document: '123.456.789-00',
            email: 'maria@email.com'
          },
          vehicle: {
            brand: 'Volkswagen',
            vehicle_model: 'Gol 1.6',
            year: 2022,
            license_plate: 'ABC-5678'
          },
          payment: {
            link: 'https://checkout.stripe.com/c/pay/cs_test_a1',
            status: 'pending',
            price: '1000.0',
            external_id: 'cs_test_a1'
          }
        }
      ].to_json
    end
    let(:query_response) do
      {
        data: {
          policiesQuery: [
            {
              effectiveFrom: '2024-03-19',
              effectiveUntil: '2025-03-19',
              status: 'draft',
              insuredPerson: {
                name: 'Maria Silva',
                document: '123.456.789-00',
                email: 'maria@email.com'
              },
              vehicle: {
                brand: 'Volkswagen',
                vehicleModel: 'Gol 1.6',
                year: 2022,
                licensePlate: 'ABC-5678'
              },
              payment: {
                link: "https://checkout.stripe.com/c/pay/cs_test_a1",
                status: "pending",
                price: 1000.0
              }
            },
          ]
        }
      }
    end

    it 'return policy info' do
      stub_request(:get, "#{ENV['APP_ONE_PATH']}/policies/").to_return(status: 200, body: http_response)

      graphql_request

      expect(JSON.parse(response.body).deep_symbolize_keys).to eq(query_response.deep_symbolize_keys)
    end
  end

  context 'when policies does NOT exist' do
    let(:query_response) do
      {
        data: { 'policiesQuery': [] }
      }
    end

    it 'return policy info' do
      stub_request(:get, "#{ENV['APP_ONE_PATH']}/policies/").to_return(status: 200, body: {}.to_json)

      graphql_request

      expect(JSON.parse(response.body).deep_symbolize_keys).to eq(query_response.deep_symbolize_keys)
    end
  end
end
