SCHEDULER.every '10m', first_in: 0 do |job|
  balance = Moco::HourBalance.new.value

  send_event('hour_balance', { current: balance, status: balance.to_f < 0 ? 'danger' : nil })
end
