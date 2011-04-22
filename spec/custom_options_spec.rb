require 'spec_helper'

describe 'Sinatra::TinyAuth with custom options' do

  before(:each) do
    FileUtils.rm File.join(File.dirname(__FILE__), 'dummy', 'tmp', 'custom_token'), :force => true
    FileUtils.rm File.join(File.dirname(__FILE__), 'dummy', 'tmp', 'token'), :force => true
  end

  def app
    BlankTestApp
  end
  
  it 'overrides defaults with custom options' do
    customize_test_app :login_path => '/foo', :logout_path => '/bar'
    
    app.settings.tiny_auth.should == {
        :login_path => '/foo',
        :logout_path => '/bar',
        :login_form_template => File.join(app.settings.views, 'login.haml'),
        :token_path => File.join(app.settings.root, 'tmp', 'token'),
        :password_digest_path => File.join(app.settings.root, 'tmp', 'password_digest'),
        :login_destination => '/',
        :logout_destination => '/'
    }
  end
  
  it 'respects the login_path option' do
    customize_test_app :login_path => '/foo'
    
    get '/login'
    last_response.should be_not_found
    
    get '/foo'
    last_response.should_not be_not_found
  end
  
  it 'respects the logout_path option' do
    customize_test_app :logout_path => '/foo'
    
    get '/logout'
    last_response.should be_not_found
    
    get '/foo'
    last_response.should_not be_not_found
  end
  
  it 'respects the login_form_template option' do
    customize_test_app :login_form_template => File.join(app.settings.views, 'login.erb')
    
    get '/login'
    last_response.body.should match(/erb template/)
  end
  
  it 'respects the token_path option' do
    customize_test_app :token_path => File.join(app.settings.root, 'tmp', 'custom_token')
    
    post '/login', :password => 'test'
    
    File.exists?(File.join(File.dirname(__FILE__), 'dummy', 'tmp', 'custom_token')).should be_true
    File.exists?(File.join(File.dirname(__FILE__), 'dummy', 'tmp', 'token')).should be_false
  end
  
  it 'respects the password_digest_path option' do
    customize_test_app :password_digest_path => File.join(app.settings.root, 'tmp', 'custom_password_digest')
    
    post '/login', :password => 'foobar'
    
    last_response.should be_redirect
    URI.parse(last_response.location).path.should == "/"
  end
  
  it 'respects the login_destination option' do
    customize_test_app :login_destination => '/the_moon'
    
    post '/login', :password => 'test'
    
    URI.parse(last_response.location).path.should == "/the_moon"
  end
  
  it 'respects the logout_destination option' do
    customize_test_app :logout_destination => '/the_heart_of_the_sun'
    
    post '/login', :password => 'test'
    get '/logout'
    
    URI.parse(last_response.location).path.should == "/the_heart_of_the_sun"
  end
end
