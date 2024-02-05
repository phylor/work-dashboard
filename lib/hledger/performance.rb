require "yaml"
require "date"
require "csv"
require "active_support/isolated_execution_state"
require "active_support/core_ext/date/calculations"

module Hledger
  class Performance
    def total(beginning_date, unbilled = false)
      clients = Dir["#{clients_directory}/*"]
        .map(&File.method(:basename))
        .map { |filename| filename.gsub(/\.yml$/, "") } - %w[clients]

      csv_text = `hledger -f #{timeclock_filename} bal #{clients.map { |client| client["id"] }.join(" ")} #{unbilled ? "" : "not:unbilled"} -1 -b #{beginning_date} --output-format csv`
      csv = CSV.parse(csv_text, headers: true)

      hours_text = csv[-1]["balance"]
      hours_text.match(/^([\d.]+)h$/)[0].to_f
    end

    def value
      beginning_of_month = Date.today.beginning_of_month.strftime("%Y-%m-%d")

      billed = total(beginning_of_month).round
      unbilled = total(beginning_of_month, true).round
      unbilled.to_f.zero? ? 100 : (billed / unbilled.to_f * 100).round
    end

    private

    def clients_directory
      ENV.fetch("HLEDGER_CLIENTS")
    end

    def timeclock_filename
      ENV.fetch("HLEDGER_TIMECLOCK")
    end
  end
end
