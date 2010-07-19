module Passport
  module Oauth
    module Context
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        
        def provider
          find(:oauth_provider)
        end
        
        def token_class
          Passport.token(provider)
        end
        
        # the token from the response parameters
        def token
          version == 1.0 ? params_key(:oauth_token) : params_key(:code)
        end
        
        def request_token
          version == 1.0 ? session_key(:oauth_request_token) : nil
        end
        
        def request_secret
          version == 1.0 ? session_key(:oauth_request_token_secret) : params_key(:code)
        end
        
        def phase
          return "request" if request?
          return "response" if response?
          return "none"
        end

        def verifier
          params_key(:verifier)
        end

        # the version of oauth we're using.  Accessed from the OauthToken subclass
        def version
          token_class.version
        end
        
        # the Oauth gem consumer, whereby we can make requests to the server
        def consumer
          token_class.consumer
        end
        
        def callback_url(options = {})
          "http://localhost:4567"
        end
        
        def inspect
          "#<Passport::Oauth::Protocol @version='#{version}' @token='#{token.inspect}' @phase='#{phase}'>"
        end
      end
      
      module InstanceMethods
        
      end
    end
  end
end
