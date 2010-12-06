require 'sinatra/base'
require 'sinatra/tiny_auth/helpers'

module Sinatra
  module TinyAuth


    def self.registered(app)

      app.helpers Sinatra::TinyAuth::Helpers
      app.enable :sessions
      
      app.set :login_path, '/login'
      app.set :login_form_template, File.join(app.settings.views, 'login.haml')
      app.set :token_path, File.join(app.settings.root, 'tmp', 'token')
      app.set :password_digest_path, File.join(app.settings.root, 'tmp', 'password_digest')
      app.set :login_destination, '/'
      app.set :logout_destination, '/'

      app.get "#{app.settings.login_path}/?" do
        Tilt.new(settings.login_form_template).render
      end

      app.post "#{app.settings.login_path}/?" do
        if check_login(params[:password])
          redirect settings.login_destination
        else
          redirect settings.login_path
        end
      end

      app.get '/logout/?' do
        logout!
        redirect settings.logout_destination
      end
    end
  end
end

