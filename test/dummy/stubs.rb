module Passport
  module Stubs
    module Oauth
      def stub_oauth_consumer(fake_token = "a_token", fake_secret = "a_secret", fake_id = "a_id")
        # token_request(http_method, path, token = nil, request_options = {}, *arguments)
        stub.instance_of(OAuth::Consumer).token_request do |http_method, path, token, request_options, *arguments|
          {:oauth_token => fake_token, :oauth_token_secret => fake_secret, :user_id => fake_id}
        end
      end
    
      def stub_oauth_redirect
        stub(Passport::Oauth::Protocol).redirect
      end
      
      def stub_oauth_clear_session
        stub(Passport::Oauth::Protocol).clear
      end
    end
  end
end
