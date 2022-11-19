require "netatmo"

module Weather
  class Wind
    def value
      client = Netatmo::Client.new
      station_data = client.get_station_data
      base_station = station_data.devices.first

      base_station.wind_gauge.wind.wind_strength
    end
  end
end
