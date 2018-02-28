SCHEDULER.every '8h', first_in: 0 do |job|
  days = Moco::DaysLeft.new.value

  send_event('days_left', { current: days })
end
