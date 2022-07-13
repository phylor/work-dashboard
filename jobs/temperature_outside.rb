SCHEDULER.every '10m', first_in: 0 do |job|
  temperature = Weather::TemperatureOutside.new.value

  send_event('temperature_outside', { current: temperature })
end
