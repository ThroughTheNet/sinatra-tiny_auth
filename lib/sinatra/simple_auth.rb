require 'sinatra/base'
require 'sinatra/simple_auth/helpers'

module Sinatra
  module SimpleAuth


    def self.registered(app)

      app.helpers Sinatra::SimpleAuth::Helpers
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

