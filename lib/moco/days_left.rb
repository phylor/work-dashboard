require 'mechanize'

class Moco::DaysLeft
  include Moco

  def value
    login do |browser|
      browser.get 'https://simplificator.mocoapp.com/reports/users_activities'

      avatar = browser.page.css(".reporting img[title='#{ENV['MOCO_NAME']}']").first
      table_row = avatar.parent.parent

      days = table_row.css('td')[1].css('.tc')
      days
        .map { |day| day.css('component').count > 0 ? nil : day.css('div').count }
        .compact
        .select { |div_count| div_count <= 3 }
        .count
    end
  end
end
