# frozen_string_literal: true

class StripeController < ApplicationController
  protect_from_forgery except: :webhook
  ENDPOINT_SECRET = ENV['ENDPOINT_SECRET']

  def webhook
    payload = request.body.read
    event = nil

    # Check if webhook signing is configured.
    # Retrieve the event by verifying the signature using the raw body and secret.
    signature = request.env['HTTP_STRIPE_SIGNATURE']

    begin
      event = Stripe::Webhook.construct_event(
        payload, signature, ENDPOINT_SECRET
      )
    rescue JSON::ParserError => e
      # Invalid payload
      puts "Error parsing payload: #{e.message}"
      head :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      puts "⚠️  Webhook signature verification failed. #{e.message}"
      head :bad_request
      return
    end
    response = false
    session = event.data.object
    case event.type
    when 'checkout.session.completed', 'checkout.session.expired'
      response = UpdateStripePaymentService.execute(session)
    else
      puts "Unhandled event type: #{event.type}"
      response = true
    end

    return head :ok if response

    head :bad_request
  end
end
