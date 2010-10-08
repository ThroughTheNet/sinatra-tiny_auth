require 'sinatra/base'
require 'sinatra/really_simple_auth/helpers'

module Sinatra
  module ReallySimpleAuth


    def self.registered(app)

      app.helpers Sinatra::ReallySimpleAuth::Helpers
      app.enable :sessions

      app.set :login_destination, '/'
      app.set :logout_destination, '/'

      app.get '/login/?' do
        haml :login
      end

      app.post '/login/?' do
        if check_login(params[:password])
          redirect settings.login_destination
        else
          redirect '/login'
        end
      end

      app.get '/logout/?' do
        logout!
        redirect settings.logout_destination
      end
    end
  end
end

