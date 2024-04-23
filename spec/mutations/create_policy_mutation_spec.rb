# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreatePolicyMutation, type: :request do
  context 'when all attributes are sent' do
    let(:mutation_string) do
      <<-GRAPHQL
        mutation {
          createPolicy(
            policy: {
              effectiveFrom: "2022-03-15"
              effectiveUntil: "2023-03-15"
              insuredPerson: {
                name: "Maria Silva",
                document: "111.111.111-11",
                email: "maria@email.com"
              }
              vehicle: {
                brand: "Volkswagen"
                vehicleModel: "Gol 1.6"
                year: "2022"
                licensePlate: "ABC-1111"
              }
            }
          ) { response }
        }
      GRAPHQL
    end

    context 'and connection successed' do
      let(:mutation_response) do
        { 'data': { 'createPolicy': {'response': 200 } } }
      end

      it 'publish message' do
        allow(BunnyConnectionService)
          .to receive(:publish_message)
          .and_return(true)

        post '/graphql', params: { query: mutation_string }.to_json, headers: { "CONTENT_TYPE"=>'application/json' }

        expect(JSON.parse(response.body).deep_symbolize_keys).to eq(mutation_response.deep_symbolize_keys)
      end
    end

    context 'and connection fails' do
      it 'publish message' do
        allow(BunnyConnectionService)
          .to receive(:publish_message)
          .and_raise(StandardError)

        post '/graphql', params: { query: mutation_string }.to_json, headers: { "CONTENT_TYPE"=>'application/json' }

        expect(JSON.parse(response.body).key?('errors')).to be_truthy
      end
    end
  end

  context 'when missing attributes' do
    let(:mutation_without_effective_from) do
      <<-GRAPHQL
        mutation {
          createPolicy(
            policy: {
              effectiveUntil: "2023-03-15"
              insuredPerson: {
                name: "Maria Silva",
                document: "111.111.111-11",
                email: "maria@email.com"
              }
              vehicle: {
                brand: "Volkswagen"
                vehicleModel: "Gol 1.6"
                year: "2022"
                licensePlate: "ABC-1111"
              }
            }
          ) {
            response {
              status
              errors
            }
          }
        }
      GRAPHQL
    end
    context 'and connection successed' do
      let(:error_message) do
        "Argument 'effectiveFrom' on InputObject 'PolicyInput' is required. Expected type String!"
      end

      it 'publish message' do
        allow(BunnyConnectionService)
          .to receive(:publish_message)
          .and_return(true)

        post '/graphql', params: { query: mutation_without_effective_from }.to_json, headers: { "CONTENT_TYPE"=>'application/json' }

        parsed_response = JSON.parse(response.body).deep_symbolize_keys

        expect(parsed_response[:errors].first[:message]).to eq(error_message)
      end
    end
  end
end
