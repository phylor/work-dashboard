require 'netatmo'

module Weather
  class TemperatureOutside
    def value
      client = Weather::NetatmoClient.create
      station_data = client.get_station_data
      base_station = station_data.devices.first

      base_station.outdoor_module.temperature.value
    end
  end
end
