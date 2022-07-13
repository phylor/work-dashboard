require 'net/ssh'

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

            ((DateTime.now - DateTime.parse(last_backup_date)) * 24).round
          end

          backups.push({label: project, value: hours_ago})
        end
      end
    end

    backups
  end
end
