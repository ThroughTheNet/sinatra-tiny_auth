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
      URI.parse(last_response.location).path.should == "/login"
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
        Socket.stub!(:gethostname).and_return('example.org')
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
    end
    
    context 'with invalid password' do
      before(:each) do
        post '/login', :password => 'THIS IS WRONG!'
      end
    
      it 'redirects back to /login' do
        last_response.should be_redirect
        URI.parse(last_response.location).path.should == "/login"
      end
      
      it 'doesnt create the token file' do
        File.exists?(File.join(File.dirname(__FILE__), 'dummy', 'tmp', 'token')).should be_false
      end
    end
    
  end
  
  
end
