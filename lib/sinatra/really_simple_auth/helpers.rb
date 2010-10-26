require 'digest/sha1'
require 'socket'
require 'active_support/secure_random' unless defined?(SecureRandom)

module Sinatra
  module ReallySimpleAuth
    module Helpers

      def require_login!
        redirect '/login' unless check_authorization
      end

      def logout!
        session[:token] = nil
      end

      def check_login(password)
        hostname = Socket.gethostname
        puts hostname
        salted_crypted_password = Digest::SHA1.hexdigest(password+hostname)

        authorize! if salted_crypted_password == crypted_password_from_file
      end

      private

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
          read_token = File.read(File.join(settings.root, 'tmp/token'))
          return token == read_token
        rescue Exception
          return false
        end
      end

      def crypted_password_from_file
        File.read(File.join(settings.root, 'tmp/password_digest'))
      end
    end
  end
end

