require 'yaml'
require 'date'
require 'csv'
require 'active_support/core_ext/date/calculations'

module Hledger
  class Projects
    def total(beginning_date, unbilled = false)
      clients = YAML.load(File.read(clients_filename))['clients']

      csv_text = `hledger -f #{timeclock_filename} bal #{unbilled ? '' : 'not:unbilled'} -1 -b #{beginning_date} --output-format csv`
      csv = CSV.parse(csv_text, headers: true)

      csv.map do |row|
        client = row['account']

        next if client == 'total'

        hours = row['balance'].match(/^([\d.]+)h$/)[0].to_f

        {
          label: client,
          value: hours
        }
      end.compact
    end

    def value
      beginning_of_week = Date.today.beginning_of_week.strftime('%Y-%m-%d')

      total(beginning_of_week, true)
    end

    private

    def clients_filename
      ENV.fetch('HLEDGER_CLIENTS')
    end

    def timeclock_filename
      ENV.fetch('HLEDGER_TIMECLOCK')
    end
  end
end
