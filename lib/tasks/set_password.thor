# require 'thor'

# module Sinatra
#   module TinyAuth
#     class Tasks < Thor
#       include Thor::Actions

#       namespace :tiny_auth
#       desc 'set', 'set a new password for tiny_auth'
#       def set

#         tty_state = `stty -g`
#         raise "stty(1) not found" unless $?.success?

#         begin
#           system "stty -echo"
#           password = ask('New password:')
#           password_confirmation = ask('Confirm new password:')
#         ensure
#           system "stty #{tty_state}"
#         end

#       end
#     end
#   end
# end
