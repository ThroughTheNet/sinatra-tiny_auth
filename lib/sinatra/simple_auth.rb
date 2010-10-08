require 'sinatra/base'

module Sinatra
  module SimpleAuth
    module Helpers

      def authorize!
        token = SecureRandom.hex(16)
        session[:token] = token
        path = File.join(settings.root, 'token')
        begin
          File.open(path, 'w') {|f| f.write(token) }
          true
        rescue Exception => e
          throw :halt, [403, haml(:error)]
        end
      end

      def require_authorization!(token = session[:token])
        begin
          read_token = File.read(File.join(File.dirname(__FILE__), 'token'))
          return token == read_token
        rescue Exception
          throw :halt, [403, haml(:error)]
        end
      end

      def check_login(password)
        authorize! if Digest::SHA1.hexdigest(password) == options.password_digest
      end

      def logout!
        session[:token] = nil
      end

    end

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

