module Sinatra
  module TinyAuth
    module Helpers

      def require_login!
        redirect settings.tiny_auth[:login_path] unless logged_in?
      end

      def logout!
        session[:token] = nil
      end

      def logged_in?
        @logged_in ||= !!Authorizer.check_authorization(session[:token])
      end

      def do_login(password)
        if Authorizer.check_password(password)
          authorize!
        else
          logout!
        end
      end

      private

        def authorize!
          session[:token] = Authorizer.generate_token!
        end

    end
  end
end
