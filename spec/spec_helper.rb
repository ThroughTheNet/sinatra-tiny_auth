$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'sinatra/base'
require 'sinatra/tiny_auth'
require 'rspec'
require 'rack/test'
require 'fileutils'

ENV["RACK_ENV"] ||= 'test'
Sinatra::Base.set :environment, :test

Rspec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods
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
