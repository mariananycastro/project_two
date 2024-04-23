# frozen_string_literal: true
require 'net/http'

class GraphqlController < ApplicationController
  skip_before_action :verify_authenticity_token
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    jwt_token = request.headers['Authorization']&.split(' ')&.last

    decoded_token = JWT.decode(jwt_token, ENV['JWT_SECRET'], true, algorithm: ENV['JWT_ALGORITHM'])
    puts 'exp'
    puts decoded_token.first['exp'] 

    query = JSON.parse(decoded_token[0])['query']

    # rescue JWT::ExpiredSignature
    #   render json: { error: 'JWT token has expired' }, status: :unauthorized
    # rescue JWT::DecodeError
    #   render json: { error: 'Invalid JWT token' }, status: :unauthorized
    # end

    variables = prepare_variables(params[:variables])

    result = AppSchema.execute(query, variables: variables)
    render json: result
  rescue StandardError => e
    handle_error(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
