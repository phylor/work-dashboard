require "netatmo"

module Weather
  class TemperatureInside
    def value
      client = Weather::NetatmoClient.create
      station_data = client.get_station_data
      base_station = station_data.devices.first

      base_station.indoor_modules.first.temperature.value
    end
  end
end
