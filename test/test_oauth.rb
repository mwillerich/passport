require File.dirname(__FILE__) + '/test_helper.rb'

module Passport
  class OauthTest < ActiveSupport::TestCase
    
    # twitter is the easiest to work with
    context "Basic User" do
      setup do
        @user = ::User.new(:login => "viatropos")
      end
      
      should "not have anything to do with oauth by default" do
        assert @user.save
      end
    end
    
    context "Oauth" do
      setup do
        # stub
        stub_oauth_consumer("a_token", "a_secret", "a_id")
        stub_oauth_redirect
        stub_oauth_clear_session
        
        @protocol = Passport::Oauth::Protocol
        @token_class = TwitterToken
        @callback_url = "http://localhost:4567/signup"
        @verifier     = "a_verifier"
      end
      
      context "Oauth Token (TwitterToken)" do

        should "have a credentials hash" do
          hash = @token_class.credentials
          assert_equal "app_key", hash[:key]
          assert_equal "app_secret", hash[:secret]
        end

        should "have a consumer_settings hash" do
          hash = @token_class.consumer_settings
          assert_equal "http://api.twitter.com", hash[:site]
          assert_equal "http://api.twitter.com/oauth/authenticate", hash[:authorize_url]
        end

        should "produce an authorize hash" do
          hash = @token_class.authorize(@callback_url)
          assert_equal "http://api.twitter.com/oauth/authenticate?oauth_token=a_token", hash[:url]
          assert_equal "a_token", hash[:token]
          assert_equal "a_secret", hash[:secret]
        end

        should "produce an access hash (without identify)" do
          hash = @token_class.access(
            :oauth_verifier => @verifier,
            :token => "a_token",
            :secret => "a_secret",
            :identify => false
          )
          assert_equal "a_token", hash[:token]
          assert_equal "a_secret", hash[:secret]
        end

        should "produce an access hash (with identify)" do
          hash = @token_class.access(
            :oauth_verifier => @verifier,
            :token => "a_token",
            :secret => "a_secret"
          )
          assert_equal "a_token", hash[:token]
          assert_equal "a_secret", hash[:secret]
          assert_equal "a_id", hash[:key]
        end
      end
      
      context "Oauth token finders (TwitterToken)" do
        setup do
          @token = @token_class.create!(:key => "a_key", :token => "a_token", :secret => "a_secret")
        end
        
        should "find by key" do
          found = @token_class.find_by_key("a_key")
          assert_equal @token, found
        end
        
        should "find by key or token" do
          found = @token_class.find_by_token("a_token")
          assert_equal @token, found
          
          found = @token_class.find_by_key_or_token(nil, "a_token")
          assert_equal @token, found
          
          found = @token_class.find_by_key_or_token("a_key", nil)
          assert_equal @token, found
        end
        
        teardown do
          @token_class.destroy_all
        end
      end

      context "Oauth with Protocol, request only (TwitterToken)" do
        setup do
          params = {
            :authentication_type => "user",
            :oauth_provider => "twitter",
            :user => {
              :login => "viatropos"
            }
          }
          get "/signup", params
        end
        
        should "be a request" do
          assert last_response.ok?
          assert_equal TwitterToken, @protocol.token_class
          assert_equal true, @protocol.request?
          # request? == (params? && provider? && !response?)
          assert_equal true, @protocol.params?
          assert_equal true, @protocol.provider?
          assert_equal false, @protocol.response?
          assert_equal true, @protocol.active?
          assert_equal true, Passport.process?
          assert_equal false, Passport.approve?
        end
        
        should "have stored params in session" do
          assert_equal "user", Rack::Context.params_key(:authentication_type)
          assert_equal "user", Rack::Context.session_key(:authentication_type)
          assert_equal "user", @protocol.authentication_type
          
          assert_equal "twitter", Rack::Context.params_key(:oauth_provider)
          assert_equal "twitter", Rack::Context.session_key(:oauth_provider)
          assert_equal "twitter", @protocol.provider
          
          assert_equal "a_token", Rack::Context.session_key(:oauth_request_token)
          assert_equal "a_secret", Rack::Context.session_key(:oauth_request_token_secret)
          
          assert_equal "User", Rack::Context.session_key(:auth_request_class)
          assert_equal "oauth", Rack::Context.session_key(:auth_method)
          assert_equal "post", Rack::Context.session_key(:auth_callback_method)
        end
        
        should "store user attributes into session" do
          assert_equal({"login" => "viatropos"}, Rack::Context.params_key(:user))
          assert_equal({"login" => "viatropos"}, Rack::Context.session_key(:auth_attributes))
        end
      end

      context "Oauth with Protocol, callback (TwitterToken)" do
        setup do
          # fake oauth callback params
          params = {
            :oauth_token => "a_token",
            "set_session" => "true"
          }
          # pretending we've saved these in the session
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
          # we don't want it to clear the session in the test, so we can check it
          get "/signup", params
        end
        
        should "be a response" do
          assert_equal TwitterToken, @protocol.token_class
          assert_equal false, @protocol.request?
          # request? == (params? && provider? && !response?)
          assert_equal true, @protocol.params?
          assert_equal true, @protocol.provider?
          assert_equal true, @protocol.response?
          assert_equal true, @protocol.active?
          assert_equal false, Passport.process?
          assert_equal true, Passport.approve?
        end
        
        should "have created a token" do
          token = @token_class.find_by_token("a_token")
          assert_equal "a_id", token.key
          assert_equal "a_token", token.token
          assert_equal "a_secret", token.secret
        end
        
        should "clear the session" do
          [:auth_request_class,
            :authentication_type,
            :auth_method,
            :oauth_provider,
            :auth_callback_method,
            :oauth_request_token,
            :oauth_request_token_secret
          ].each do |key|
            assert Rack::Context.session_key(key)
            Rack::Context.session.delete(key)
            assert_equal nil, Rack::Context.session_key(key)
          end
        end
        
        teardown do
          AccessToken.destroy_all
        end
        
      end
      
      context "All Oauth Tokens" do

        should "all 1.0 tokens respond to #accces and have a key" do
          [
            TwitterToken,
            GoogleToken,
            FoursquareToken,
            LinkedInToken,
            MyspaceToken,
            VimeoToken,
            YahooToken,
            CliqsetToken,
            ExponoToken,
            MeetupToken,
            PhotobucketToken,
            SoundcloudToken,
            YammerToken,
            BrightkiteToken,
            EvernoteToken,
            NetflixToken
          ].each do |token_class|
            # key must be defined, as a block, symbol, or string
            assert token_class.key
            
            # does access at least work
            hash = token_class.access(
              :oauth_verifier => @verifier,
              :token => "a_token",
              :secret => "a_secret",
              :identify => false
            )
            assert_equal "a_token", hash[:token]
            assert_equal "a_secret", hash[:secret]
          end
        end
      end
    end
  end
end
