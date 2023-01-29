require "net/ssh"
require "time"

class Backups
  def value(host)
    backups = []

    Net::SSH.start(host.to_s) do |ssh|
      output = ssh.exec!("cat /var/backups/stats")
      stats = CSV.parse(output, col_sep: ";")

      # First line is the datetime of last check run
      projects = stats.slice(1, stats.length)

      projects.each do |project, datetime|
        matches = datetime&.match(/(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/)

        hours_ago = if matches
          last_backup_date = matches[0]

          ((Time.now - Time.parse(last_backup_date)) / 3600).round
        end

        backups.push({
          label: project,
          value: hours_ago,
          status: hours_ago && hours_ago < 24 ? "ok" : "failed"
        })
      end
    end

    backups
  end
end
