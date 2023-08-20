# frozen_string_literal: true

require "netatmo"

module Weather
  module NetatmoClient
    def self.create
      client = Netatmo::Client.new
      client.access_token = ENV["NETATMO_ACCESS_TOKEN"]
      client.refresh_token = ENV["NETATMO_REFRESH_TOKEN"]
      client.expires_at = Time.now
      client.fetch_token

      client
    end
  end
end
