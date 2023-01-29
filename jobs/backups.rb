SCHEDULER.every "1h", first_in: 0 do |job|
  backups = Backups.new.value(YAML.load_file("backup_projects.yml"))

  send_event("backups", {items: backups})
end
