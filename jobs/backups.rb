SCHEDULER.every "1h", first_in: 0 do |job|
  backups = Backups.new.value

  send_event("backups", {items: backups})
end
