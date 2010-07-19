require 'sinatra'
require 'json'
require 'active_support'
require 'active_support/core_ext'
require File.dirname(__FILE__) + '/../../lib/passport'

enable :sessions
use Rack::Context
use Passport::Filter

get "/" do
  "Hello World"
end

get "/signup" do
  if params["set_session"]
    session = {
      :authentication_type => "user",
      :oauth_provider => "twitter",
      :oauth_request_token => "a_token",
      :oauth_request_token_secret => "a_secret",
      :auth_request_class => "User",
      :auth_method => "oauth",
      :auth_callback_method => "create",
      :auth_attributes => {
        :login => "viatropos"
      }
    }
    Rack::Context.session.merge!(session)
  end
  @user = User.new(params[:user])
  @user.save do |result|
    puts "save... #{result}"
  end
end

# mock oauth 1.0 provider, like twitter
get "/mock-oauth-1-provider" do
  redirect "/signup"
end

# mock oauth 2.0 provider, like facebook
get "/mock-oauth-2-provider" do
  params = {:oauth_verifier => "xyz"}
  redirect "/signup?#{params.to_query}"
end

get "/mock-openid-provider" do
  
end