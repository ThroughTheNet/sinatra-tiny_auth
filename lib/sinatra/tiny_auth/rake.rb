require 'bcrypt'
require 'rake'
# require 'digest/sha1'
require 'socket'
require 'fileutils'

desc 'change the password'
namespace 'tiny_auth' do

  task 'set_password' do
    state = `stty -g`

    raise "stty(1) not found" unless $?.success?

    begin
      system "stty -echo"
      $stdout.print "new password: "
      $stdout.flush
      password = $stdin.gets.chomp
      $stdout.puts
    ensure
      system "stty #{state}"
    end

    begin
      system "stty -echo"
      $stdout.print "confirm new password: "
      $stdout.flush
      password_confirmation = $stdin.gets.chomp
      $stdout.puts
    ensure
      system "stty #{state}"
    end

    raise 'Passwords do not match! Try again.' unless password == password_confirmation

    crypted_password = BCrypt::Password.create(password)

    File.open('tmp/password_digest', 'w') do |f|
      f.write(crypted_password)
      f.chmod 0600
    end

   File.open('tmp/token', 'w') do |f|
      f.write(nil)
      f.chmod 0600
    end

    puts 'Success!'
  end
end

