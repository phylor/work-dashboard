require 'dashing'

configure do
  use Rack::Session::Cookie, secret: ENV['RACK_SECRET']

  # See http://www.sinatrarb.com/intro.html > Available Template Languages on
  # how to add additional template languages.
  set :template_languages, %i[html erb]
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
