require 'mechanize'

class RubyVersions
  def stable
    browser = Mechanize.new
    browser.get 'https://www.ruby-lang.org/en/downloads/'

    release_heading = browser.page.css('strong:contains("Stable releases:")').first
    versions = release_heading.parent.css('li a').text

    versions.scan /Ruby (\d\.\d\.\d)/
  end
end
