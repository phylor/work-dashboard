require 'open-uri'

SCHEDULER.every '10m', first_in: 0 do |job|
  data = URI.parse("http://sugarcubes.ch/api/sugar_cubes?token=#{ENV['SUGAR_CUBES_TOKEN']}").read

  json = JSON.parse(data)
  points = json
    .map { |date, cubes| [date, cubes] }
    .sort_by { |entry| Date.parse(entry[0]) }
    .map.with_index { |entry, index| { x: index, y: entry[1].round(2) } }

  send_event('sugar_cubes', points: points)
end
