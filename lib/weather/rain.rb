require "netatmo"

module Weather
  class Rain
    def value
      client = Weather::NetatmoClient.create
      station_data = client.get_station_data
      base_station = station_data.devices.first

      base_station.rain_gauge.rain.value
    end
  end
end
