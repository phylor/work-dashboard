SCHEDULER.every "10m", first_in: 0 do |job|
  rain = Weather::Rain.new.value

  send_event("rain", {current: rain})
end
