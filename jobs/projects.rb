SCHEDULER.every '10m', first_in: 0 do |job|
  projects = Hledger::Projects.new.value

  send_event('projects', { items: projects })
end
