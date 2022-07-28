SCHEDULER.every "1d", first_in: 0 do |job|
  disks = GrafanaQuery.new.call

  send_event("disks", {items: disks})
end
