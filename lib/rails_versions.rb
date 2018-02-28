require 'mechanize'

class RailsVersions
  def latest
    versions.first
  end

  private

  def versions
    return @versions if @versions

    browser = Mechanize.new
    browser.get 'https://rubygems.org/gems/rails/versions'

    releases = browser.page.css('.versions li a').map(&:text)

    @versions = releases.select { |version| version.match /^\d\.\d\.\d$/ }
  end
end
