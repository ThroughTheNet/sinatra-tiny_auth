require 'digest/sha1'
require 'socket'
require 'fileutils'

desc 'change the password'
namespace 'really_simple_auth' do

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

    hostname = Socket.gethostname
    salted_crypted_password = Digest::SHA1.hexdigest(password+hostname)

    File.open('password_digest', 'w') do |f|
      f.write(salted_crypted_password)
      f.chmod 0600
    end

    FileUtils.rm 'token' if File.exists? 'token'

    puts 'Success!'
  end
end

