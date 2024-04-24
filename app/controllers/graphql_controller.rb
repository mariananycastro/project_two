# frozen_string_literal: true
require 'net/http'

class GraphqlController < ApplicationController
  skip_before_action :verify_authenticity_token


  def execute
    query = params[:query]
    jwt_token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = JWT.decode(jwt_token, ENV['JWT_SECRET'], true, algorithm: ENV['JWT_ALGORITHM'])

    result = AppSchema.execute(query, variables: variables)
    render json: result
  rescue StandardError => e
    handle_error(e)
  end

  private

  def handle_error(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
