require 'omniauth/google_oauth2'
require 'dashing'

configure do
  use Rack::Session::Cookie, secret: ENV['RACK_SECRET']

  # See http://www.sinatrarb.com/intro.html > Available Template Languages on
  # how to add additional template languages.
  set :template_languages, %i[html erb]

  helpers do
    def protected!
      redirect '/auth/g' unless session[:user_id]
    end
  end

  use OmniAuth::Builder do
    provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_SECRET'], name: 'g', hd: ENV['GOOGLE_DOMAIN']
  end

  get '/auth/g/callback' do
    if auth = request.env['omniauth.auth']
      session[:user_id] = auth['info']['email']
      redirect '/'
    else
      redirect '/auth/failure'
    end
  end

  get '/auth/failure' do
    'Nope.'
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
