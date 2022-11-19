require "csv"
require "date"
require "active_support/isolated_execution_state"
require "active_support/core_ext/date/calculations"
require "gruff"

module Hledger
  class DailyHours
    def create_image
      one_week_ago = Date.today.at_beginning_of_week.strftime("%Y-%m-%d")
      year = Date.today.year
      daily_hours_output = `hledger bal -f #{timeclock_filename} -p 'every day' -1 -b #{one_week_ago} -O csv`

      data = CSV.parse(daily_hours_output)

      dates = data.first.slice(1..-1).map do |date|
        "#{date}\n#{Date.parse(date).strftime("%a")}"
      end
      hours = data.last.slice(1..-1)
      labels = (0..dates.count - 1).to_a.zip(dates)
      projects = data.slice(1..-2)

      g = Gruff::StackedBar.new
      g.title = "Daily work hours"
      g.labels = labels.to_h
      g.colors = [
        "#a9dada", # blue
        "#aedaa9", # green
        "#daaea9", # peach
        "#dadaa9", # yellow
        "#a9a9da", # dk purple
        "#daaeda", # purple
        "#dadada", # grey
        "#ad6666"
      ]
      projects.each.with_index do |project, index|
        project =
          g.data project.first, project.slice(1..-1).map(&:to_f)
      end
      g.write "assets/images/daily_hours.png"
    end

    private

    def timeclock_filename
      ENV.fetch("HLEDGER_TIMECLOCK")
    end
  end
end
