$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'sinatra/base'
require 'sinatra/tiny_auth'
require 'RSpec'
require 'rack/test'
require 'fileutils'
require 'ap'

load 'tasks/set_password.thor'

class Thor
  module Shell
    class Basic
      def say(message = nil, color = nil, force_new_line = nil)
        #this stops thor littering the console during tests
      end
    end
  end
end

ENV["RACK_ENV"] ||= 'test'
Sinatra::Base.set :environment, :test

module SpecHelperMethods
  def customize_test_app(options = {})
    BlankTestApp.reset!
    BlankTestApp.set :tiny_auth, options
    BlankTestApp.register Sinatra::TinyAuth
  end
end

RSpec.configure do |config|
  config.mock_with :RSpec
  config.include Rack::Test::Methods
  config.include SpecHelperMethods
end

class TestApp < Sinatra::Base
  set :root, File.join(File.dirname(__FILE__), 'dummy')
  register Sinatra::TinyAuth

  get '/private' do
    require_login!
    'success'
  end

  get '/public' do
    'success'
  end
end

class BlankTestApp < Sinatra::Base
  set :root, File.join(File.dirname(__FILE__), 'dummy')
end
