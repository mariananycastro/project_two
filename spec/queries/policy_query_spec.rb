# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::PolicyResolver, type: :request do
  context 'when sendind id' do
    let(:headers) do
      expires_at = 10.hours.from_now
      jwt_token = JWT.encode({ exp: expires_at.to_i }, ENV['JWT_SECRET'], ENV['JWT_ALGORITHM'])

      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{jwt_token}"
      }
    end
    subject(:graphql_request) do
      post '/graphql', params: { query: policy_query }.to_json, headers: headers
    end
    let(:policy_query) do
      <<-GRAPHQL
        query {
          policyQuery(id: #{query_id}) {
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

    context 'when policy exists' do
      let(:query_id) { 1 }
      let(:http_response) do
        {
          effective_from: '2024-03-19',
          effective_until: '2026-03-19',
          status: 'draft',
          insured_person: {
            name: 'Maria Silva',
            email: 'maria@email.com',
            document: '123.456.789-00'
          },
          vehicle: {
            brand: 'Fiat',
            vehicle_model: 'Uno 1.0',
            year: 1996,
            license_plate: 'ABC-1234'
          },
          payment: {
            link: "https://checkout.stripe.com/c/pay/cs_test_a1",
            status: "pending",
            price: 1000.0
          }
        }.to_json
      end
      let(:query_response) do
        {
          data: {
            policyQuery: {
              effectiveFrom: '2024-03-19',
              effectiveUntil: '2026-03-19',
              status: 'draft',
              insuredPerson: {
                name: 'Maria Silva',
                email: 'maria@email.com',
                document: '123.456.789-00'
              },
              vehicle: {
                brand: 'Fiat',
                vehicleModel: 'Uno 1.0',
                year: 1996,
                licensePlate: 'ABC-1234'
              },
              payment: {
                link: "https://checkout.stripe.com/c/pay/cs_test_a1",
                status: "pending",
                price: 1000.0
              }
            }
          }
        }
      end

      it 'return policy info' do
        stub_request(:get, "#{ENV['APP_ONE_PATH']}/policies/1").to_return(status: 200, body: http_response)

        graphql_request

        expect(JSON.parse(response.body).deep_symbolize_keys).to eq(query_response.deep_symbolize_keys)
      end
    end

    context 'when policy does NOT exist' do
      let(:query_id) { 1 }
      let(:query_response) do
        {
          data: {
            policyQuery: {
              effectiveFrom: nil,
              effectiveUntil: nil,
              status: nil,
              insuredPerson: nil,
              vehicle: nil,
              payment: nil
            }
          }
        }
      end

      it 'return policy info' do
        stub_request(:get, "#{ENV['APP_ONE_PATH']}/policies/1").to_return(status: 200, body: {}.to_json)

        graphql_request

        expect(JSON.parse(response.body).deep_symbolize_keys).to eq(query_response.deep_symbolize_keys)
      end
    end
  end
end
