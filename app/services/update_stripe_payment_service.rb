class UpdateStripePaymentService
  QUEUE = 'update-payment'

  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def self.execute(payload)
    new(payload).execute
  end

  def execute
    publish_message = BunnyConnectionService.publish_message(QUEUE, payload)
  end
end
