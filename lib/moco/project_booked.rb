require 'mechanize'

class Moco::ProjectBooked
  include Moco

  def initialize(project)
    @project = project
  end

  def value
    login do |browser|
      browser.get "https://simplificator.mocoapp.com/activities/performance/#{Date.today.year}"

      latest_month = browser.page.css('.nav-tabs li:not([class=disabled])').last.css('a').first
      browser.click(latest_month)

      project_hours = browser.page.css("td:contains('#{@project}') + td").first
      
      if project_hours
        project_hours.text
      else
        0
      end
    end
  end
end
