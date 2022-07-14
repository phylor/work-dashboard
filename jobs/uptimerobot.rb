require 'uptimerobot'

api_key = ENV['UPTIMEROBOT_APIKEY']

SCHEDULER.every '5m', :first_in => 0 do |job|
  client = UptimeRobot::Client.new(api_key: api_key)

  raw_monitors = client.getMonitors['monitors']

  monitors = raw_monitors.map do |monitor|
    {
      friendlyname: monitor['friendly_name'],
      status: 'S' << monitor['status'].to_s
    }
  end

  send_event('uptimerobot', { monitors: monitors } )
end
