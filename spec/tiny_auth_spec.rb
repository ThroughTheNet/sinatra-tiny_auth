require 'spec_helper'

describe Sinatra::TinyAuth do

  def app
    TestApp
  end
  
  context 'routes with the require_login! helper' do
    before(:each) do
      get '/public'
    end
  
    it 'does not redirect' do
      last_response.should be_ok
    end
  end
  
  context 'routes with the require_login! helper' do
    before(:each) do
      get '/private'
    end
    
    it "redirects to /login" do
      last_response.should be_redirect
      URI.parse(last_response.location).path.should match("/login")
    end
  end
  
  context 'logging in' do
    before(:each) do
      FileUtils.rm File.join(File.dirname(__FILE__), 'dummy', 'tmp', 'token'), :force => true
    end
    
    it 'renders the login form' do
      get '/login'
      last_response.should_not be_server_error
    end
    
    context 'with valid password' do
      before(:each) do
        post '/login', :password => 'test'
      end
      
      it "does not err" do
        last_response.should_not be_server_error
      end
      
      it 'redirects to root' do
        URI.parse(last_response.location).path.should == "/"
      end
      
      it 'creates the token file' do
        File.exists?(File.join(File.dirname(__FILE__), 'dummy', 'tmp', 'token')).should be_true
      end
      
      it 'subsequently allows access to routes with the require_login! helper' do
        get '/private'
        
        last_response.should_not be_redirect
        last_response.body.should match(/success/)
      end
    end
    
    context 'with invalid password' do
      before(:each) do
        post '/login', :password => 'THIS IS WRONG!'
      end
    
      it 'redirects back to /login' do
        last_response.should be_redirect
        URI.parse(last_response.location).path.should match("/login")
      end
      
      it 'doesnt create the token file' do
        File.exists?(File.join(File.dirname(__FILE__), 'dummy', 'tmp', 'token')).should be_false
      end
      
      it 'does not subsequently allow access to routes with the require_login! helper' do
        get '/private'
        
        last_response.should be_redirect
        URI.parse(last_response.location).path.should match("/login")
        last_response.body.should_not match(/success/)
      end
    end
    
  end
  
  
end
