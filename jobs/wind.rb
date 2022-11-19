SCHEDULER.every "10m", first_in: 0 do |job|
  wind = Weather::Wind.new.value

  send_event("wind", {current: wind})
end
