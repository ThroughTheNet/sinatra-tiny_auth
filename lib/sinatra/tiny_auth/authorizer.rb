require 'bcrypt'
require 'securerandom'

module Sinatra
  module TinyAuth
    class Authorizer
      class << self

        attr_writer :app

        def check_password(password)
          BCrypt::Password.new(read_crypted_password) == password
        end

        def generate_token!
          token = SecureRandom.hex(16)
          path = @app.settings.tiny_auth[:token_path]
          File.open(path, 'w') {|f| f.write(token) }
          token
        end

        def check_authorization(token)
          begin
            return token == read_token
          rescue Exception
            return false
          end
        end

        private

          def read_token
            File.read(@app.settings.tiny_auth[:token_path])
          end

          def read_crypted_password
            File.read(@app.settings.tiny_auth[:password_digest_path]).chomp
          end

      end
    end
  end
end
