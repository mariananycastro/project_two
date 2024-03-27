class BunnyConnectionService
  def self.publish_message(queue_name, message)
    conn = Bunny.new(hostname: 'rabbitmq', username: 'guest', password: 'guest')
    conn.start

    return false if conn.status != :open 

    ch = conn.create_channel
    queue = ch.queue(queue_name, durable: true)
    queue.publish(message.to_json)
    conn.close
  end
end
