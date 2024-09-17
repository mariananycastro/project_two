class BunnyConnectionService
  def self.publish_message(queue_name, message)
    conn = Bunny.new(
      hostname: ENV['RABBIT_HOST'],
      username: ENV['RABBIT_USER'],
      password: ENV['RABBIT_PASSWORD']
    )
    conn.start

    return false if conn.status != :open

    ch = conn.create_channel
    queue = ch.queue(queue_name, durable: true)
    queue.publish(message.to_json)
    conn.close
  end
end
