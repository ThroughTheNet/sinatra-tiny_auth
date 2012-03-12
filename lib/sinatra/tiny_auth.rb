require 'sinatra/base'
require 'sinatra/tiny_auth/helpers'
require 'sinatra/tiny_auth/authorizer'
require 'active_support/core_ext/hash/reverse_merge'
require 'sinatra/tiny_auth/rake'

class Hash
  include ActiveSupport::CoreExtensions::Hash::ReverseMerge
end

module Sinatra
  module TinyAuth


    def self.registered(app)

      app.helpers Sinatra::TinyAuth::Helpers
      app.enable :sessions unless app.sessions?

      Authorizer.app = app

      defaults = {
        :login_path => '/login/?',
        :logout_path => '/logout/?',
        :login_form_template => File.join(app.views, 'login.haml'),
        :token_path => File.join(app.root, 'tmp', 'token'),
        :password_digest_path => File.join(app.root, 'tmp', 'password_digest'),
        :login_destination => '/',
        :logout_destination => '/'
        }

      app.set :tiny_auth, Hash.new unless app.respond_to?(:tiny_auth) && app.tiny_auth.is_a?(Hash)

      app.tiny_auth.reverse_merge!(defaults)

      app.get app.tiny_auth[:login_path] do
        Tilt.new(settings.tiny_auth[:login_form_template]).render
      end

      app.post app.tiny_auth[:login_path] do
        if do_login(params[:password])
          redirect settings.tiny_auth[:login_destination]
        else
          redirect settings.tiny_auth[:login_path]
        end
      end

      app.get app.tiny_auth[:logout_path] do
        logout!
        redirect settings.tiny_auth[:logout_destination]
      end
    end
  end
end

