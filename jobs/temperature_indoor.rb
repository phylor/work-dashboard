SCHEDULER.every "10m", first_in: 0 do |job|
  temperature = Weather::TemperatureInside.new.value

  send_event("temperature_inside", {current: temperature})
end
