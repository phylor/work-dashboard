SCHEDULER.every '10m', first_in: 0 do |job|
  hours = Moco::ProjectBooked.new('DevOps').value.to_f

  display = if hours > 16
              days = hours / 8.0
              "#{days.round(2)}d"
            else
              "#{hours}h"
            end

  send_event('devops_booked', { current: display, status: hours > 16 ? 'danger' : nil })
end
