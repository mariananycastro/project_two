class UpdateStripePaymentService
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def self.execute(payload)
    new(payload).execute
  end

  def execute
    queue_name = 'update-payment'
    publish_message = BunnyConnectionService.publish_message(queue_name, payload)
  end
end
