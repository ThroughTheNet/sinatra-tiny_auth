require 'digest/sha1'
require 'socket'
require 'active_support/secure_random' unless defined?(SecureRandom)

module Sinatra
  module TinyAuth
    module Helpers

      def require_login!
        redirect settings.login_path unless check_authorization
      end

      def logout!
        session[:token] = nil
      end

      def check_login(password)
        hostname = Socket.gethostname
        salted_crypted_password = Digest::SHA1.hexdigest(password+hostname)

        if salted_crypted_password == read_crypted_password
          authorize! 
        else
          session[:token] = nil
        end
      end

      private

      def authorize!
        token = SecureRandom.hex(16)
        session[:token] = token
        path = settings.token_path
        begin
          File.open(path, 'w') {|f| f.write(token) }
          true
        rescue Exception => e
          throw :halt, [403, haml(:error)]
        end
      end

      def check_authorization(token = session[:token])
        begin
          return token == read_token
        rescue Exception
          return false
        end
      end
      
      def read_token
        File.read(settings.token_path)
      end

      def read_crypted_password
        File.read(settings.password_digest_path).chomp
      end
    end
  end
end

