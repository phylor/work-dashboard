SCHEDULER.every "10m", first_in: 0 do |job|
  co2 = Weather::Co2.new.value

  send_event("co2", {current: co2})
end
