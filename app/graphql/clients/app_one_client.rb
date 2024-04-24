module Clients
  class AppOneClient
    def self.execute(path)
      uri = URI("#{ENV['APP_ONE_PATH']}/" << path)
      response = Net::HTTP.get_response(uri.host, uri.path, uri.port)
    end
  end
end
