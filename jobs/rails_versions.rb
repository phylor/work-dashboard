SCHEDULER.every '1d', first_in: 0 do |job|
  version = RailsVersions.new.latest

  send_event('rails_versions', { text: version })
end
