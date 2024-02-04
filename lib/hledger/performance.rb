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

      csv.map do |row|
        client = row["account"]

        if client != "total"
          hours = row["balance"].match(/^([\d.]+)h$/)[0].to_f
          client_config = clients.find { |c| c["id"] == client }

          hours * client_config["cents_per_hour"].to_i
        else
          0.0
        end
      end.sum / 100.0
    end

    def value
      beginning_of_month = Date.today.beginning_of_month.strftime("%Y-%m-%d")
      beginning_of_year = Date.today.beginning_of_year.strftime("%Y-%m-%d")

      billed = total(beginning_of_month).round
      with_unbilled = total(beginning_of_month, true).round
      yearly = total(beginning_of_year).round
      with_unbilled.to_f.zero? ? 100 : (billed / with_unbilled.to_f * 100).round

      # puts "#{billed} / #{yearly}, #{percentage_billed}%"
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
