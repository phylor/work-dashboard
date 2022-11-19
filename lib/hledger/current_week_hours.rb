require "csv"
require "date"
require "active_support/isolated_execution_state"
require "active_support/core_ext/date/calculations"

module Hledger
  class CurrentWeekHours
    def value
      one_week_ago = Date.today.at_beginning_of_week.strftime("%Y-%m-%d")
      daily_hours_output = `hledger bal -f #{timeclock_filename} -0 -b #{one_week_ago} -O csv`

      data = CSV.parse(daily_hours_output)

      data.last.last.delete("h").to_f
    end

    private

    def timeclock_filename
      ENV.fetch("HLEDGER_TIMECLOCK")
    end
  end
end
