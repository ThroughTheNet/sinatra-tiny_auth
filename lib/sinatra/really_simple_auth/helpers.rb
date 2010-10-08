require 'digest/sha1'
require 'active_support/secure_random' unless defined?(SecureRandom)

module Sinatra
  module ReallySimpleAuth
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

      def check_authorization(token = session[:token])
        begin
          read_token = File.read(File.join(settings.root, 'token'))
          return token == read_token
        rescue Exception
          return false
        end
      end

      def require_login!
        redirect '/login' unless check_authorization
      end

      def check_login(password)
        authorize! if Digest::SHA1.hexdigest(password) == options.password_digest
      end

      def logout!
        session[:token] = nil
      end

    end
  end
end

