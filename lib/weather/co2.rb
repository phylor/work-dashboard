require "netatmo"

module Weather
  class Co2
    def value
      client = Netatmo::Client.new
      station_data = client.get_station_data
      base_station = station_data.devices.first

      base_station.indoor_modules.first.co2.value
    end
  end
end
