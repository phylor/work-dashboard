SCHEDULER.every "10m", first_in: 0 do |job|
  hours = Hledger::CurrentWeekHours.new.value

  send_event("current_week_hours", {current: hours})
end
