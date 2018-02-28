SCHEDULER.every '10m', first_in: 0 do |job|
  performance = Moco::Performance.new.value

  send_event('performance', { value: performance })
end
