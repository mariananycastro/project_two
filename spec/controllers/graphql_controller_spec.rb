# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlController, type: :controller do
  describe "POST #execute" do
    let(:query) do
        <<-GRAPHQL
          query {
            policiesQuery {
              effectiveFrom
            }
          }
        GRAPHQL
      end

    subject(:graphql_request) do
      request.headers['Authorization'] = "Bearer #{jwt_token}"
      post :execute, params: { query: query }
    end

    before do
      stub_request(:get, "#{ENV['APP_ONE_PATH']}/policies/").to_return(status: 200, body: {}.to_json)
      graphql_request
    end

    context "with a valid JWT token" do
      let(:jwt_token) do
        expires_at = 10.hours.from_now
        jwt_token = JWT.encode({ exp: expires_at.to_i }, ENV['JWT_SECRET'], ENV['JWT_ALGORITHM'])
      end

      it "returns a successful response" do
        expect(response).to have_http_status(200)
      end

      it "returns a JSON response with the result" do
        json_response = JSON.parse(response.body)

        expect(json_response).to include("data")
      end
    end

    context "with an invalid JWT token" do
      let(:jwt_token) do
        expires_at = 10.hours.from_now
        jwt_token = JWT.encode({ exp: expires_at.to_i }, 'invalid secret', ENV['JWT_ALGORITHM'])
      end

      it "returns an unauthorized response" do
        expect(response).to have_http_status(500)
      end

      it "returns an error message in the response" do
        json_response = JSON.parse(response.body)

        expect(json_response).to include("errors")
        expect(json_response["errors"]).to be_an(Array)
        expect(json_response["errors"].first).to include("message")
      end
    end
  end
end
