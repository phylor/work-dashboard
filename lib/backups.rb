require 'net/ssh'
require 'time'

class Backups
  def value(projects)
    backups = []
    hosts = projects.keys

    hosts.each do |host|
      Net::SSH.start(host.to_s) do |ssh|
        projects[host].each do |project|
          output = ssh.exec!("restic -r /var/backups/#{project} -p /srv/#{project}/.backup_password snapshots | tail -3 | head -1")

          matches = output.match(/(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/)

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
    end

    backups
  end
end
