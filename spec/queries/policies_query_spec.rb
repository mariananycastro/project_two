# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::PoliciesResolver, type: :request do
  let(:policies_query) do
    <<-GRAPHQL
      query {
        policiesQuery {
          effectiveFrom
          effectiveUntil
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
              }
            },
          ]
        }
      }
    end

    it 'return policy info' do
      stub_request(:get, "#{ENV['APP_ONE_PATH']}/policies/").to_return(status: 200, body: http_response)

      post '/graphql', params: { query: policies_query }.to_json, headers: { "CONTENT_TYPE"=>'application/json' }

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

      post '/graphql', params: { query: policies_query }.to_json, headers: { "CONTENT_TYPE"=>'application/json' }

      expect(JSON.parse(response.body).deep_symbolize_keys).to eq(query_response.deep_symbolize_keys)
    end
  end
end
