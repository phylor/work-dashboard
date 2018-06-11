SCHEDULER.every '10m', first_in: 0 do |_job|
  hours = Moco::ProjectBooked.new('Internal 2018 Collex').value.to_f

  display = if hours > 16
              days = hours / 8.0
              "#{days.round(2)}d"
            else
              "#{hours}h"
            end

  label = hours > 16 ? 'danger' : nil

  send_event('team_booked', current: display, status: label)
end
