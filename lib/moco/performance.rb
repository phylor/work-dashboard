require 'mechanize'

class Moco::Performance
  include Moco

  def value
    login do |browser|
      browser.get('https://simplificator.mocoapp.com/reports/users_activities')

      avatar = browser.page.css(".reporting img[title='#{ENV['MOCO_NAME']}']").first
      table_row = avatar.parent.parent
      performance_cell = table_row.css('td').last

      performance_cell.text.strip.delete('%')
    end
  end
end
