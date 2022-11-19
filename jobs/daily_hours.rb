SCHEDULER.every "10m", first_in: 0 do |job|
  Hledger::DailyHours.new.create_image

  send_event("daily_hours", {image: "/daily_hours.png"})
end
