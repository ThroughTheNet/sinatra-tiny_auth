require 'sinatra/base'

module Sinatra
  module SimpleAuth

    def self.registered(app)
      app.enable :sessions

      app.set :login_destination, '/'

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
        redirect settings.login_destination
      end
    end
  end
end

