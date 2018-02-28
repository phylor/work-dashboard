require 'mechanize'

class Moco::HourBalance
  include Moco

  def value
    login do |browser|
      browser.get "https://simplificator.mocoapp.com/activities/performance/#{Date.today.year}"

      heading = browser.page.css('h4:contains("Ist")').first

      heading.parent.css('span').last.text
    end
  end
end
