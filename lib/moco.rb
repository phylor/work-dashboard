require 'mechanize'

module Moco
  def login
    browser = Mechanize.new
    browser.get('https://simplificator.mocoapp.com')

    browser.page.forms[0]['session[email]'] = ENV['MOCO_USER']
    browser.page.forms[0]['session[password'] = ENV['MOCO_PASSWORD']
    browser.page.forms[0].submit

    yield browser
  end
end
