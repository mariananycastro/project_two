# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::PolicyResolver, type: :request do
  context 'when sendind id' do
    let(:policy_query) do
      <<-GRAPHQL
        query {
          policyQuery(id: #{query_id}) {
            id
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

    context 'when policy exists' do
      let(:query_id) { 1 }
      let(:http_response) do
        {
          'id': query_id,
          'effective_from': '2024-03-19',
          'effective_until': '2026-03-19',
          'insured_person_id': 1,
          'vehicle_id': 2,
          'insured_person': {
            'name': 'Maria Silva',
            'email': 'maria@email.com',
            'document': '123.456.789-00'
          },
          'vehicle': {
            'brand': 'Fiat',
            'vehicle_model': 'Uno 1.0',
            'year': 1996,
            'license_plate': 'ABC-1234'
          }
        }.to_json
      end
      let(:query_response) do
        {
          'data': {
            'policyQuery': {
              'id': '1',
              'effectiveFrom': '2024-03-19',
              'effectiveUntil': '2026-03-19',
              'insuredPerson': {
                'name': 'Maria Silva',
                'email': 'maria@email.com',
                'document': '123.456.789-00'
              },
              'vehicle': {
                'brand': 'Fiat',
                'vehicleModel': 'Uno 1.0',
                'year': 1996,
                'licensePlate': 'ABC-1234'
              }
            }
          }
        }
      end

      it 'return policy info' do
        stub_request(:get, "#{ENV['APP_ONE_PATH']}/policies/1").to_return(status: 200, body: http_response)

        post '/graphql', params: { query: policy_query }.to_json, headers: { "CONTENT_TYPE"=>'application/json' }

        expect(JSON.parse(response.body).deep_symbolize_keys).to eq(query_response.deep_symbolize_keys)
      end
    end

    context 'when policy does NOT exist' do
      let(:query_id) { 1 }
      let(:query_response) do
        {
          'data': {
            'policyQuery': {
              'id': nil,
              'effectiveFrom': nil,
              'effectiveUntil': nil,
              'insuredPerson': nil,
              'vehicle': nil
            }
          }
        }
      end

      it 'return policy info' do
        stub_request(:get, "#{ENV['APP_ONE_PATH']}/policies/1").to_return(status: 200, body: {}.to_json)

        post '/graphql', params: { query: policy_query }.to_json, headers: { "CONTENT_TYPE"=>'application/json' }

        expect(JSON.parse(response.body).deep_symbolize_keys).to eq(query_response.deep_symbolize_keys)
      end
    end
  end
end
