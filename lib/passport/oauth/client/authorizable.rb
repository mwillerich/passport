module Passport
  module Oauth
    module Authorizable
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        # first part in the sequece.
        # returns a <Hash>:
        #   {:url => "x", :token => "y", :secret => "z"}
        # if it's using Oauth 1.0, token and secret will be present.
        # if it's using Oauth 2.0, token and secret are not present.
        # for Oauth 1.0, save the token/secret in the session to use
        # after the redirect.
        def authorize(callback_url, options = {})
          result = {}

          if version == 1.0
            options.reverse_merge!(:scope => consumer_settings[:scope]) if consumer_settings[:scope]
            request = consumer.get_request_token({:oauth_callback => callback_url}, options)
            result[:token] = request.token
            result[:secret] = request.secret
            result[:url] = request.authorize_url
          else
            options.merge!(:redirect_uri => callback_url)
            result[:url] = consumer.web_server.authorize_url(options)
          end
          
          result
        end
        
        # get the access token
        def access(options)
          puts "ACCESS #{options.inspect}"
          if version == 1.0
            access_token = OAuth::RequestToken.new(consumer, options[:token], options[:secret]).get_access_token(:oauth_verifier => options[:oauth_verifier])
            result = {:token => access_token.token.to_s, :secret => access_token.secret.to_s}
          else
            access_token = consumer.web_server.get_access_token(options[:secret], :redirect_uri => options[:callback_url])
            result = {:token => access_token.token.to_s, :secret => options[:secret].to_s}
          end
          
          result[:key] = identify(access_token) unless options[:identify] == false
          
          result
        end
        
        def credentials
          @credentials ||= Passport.credentials(service)
        end
      end
      
      module InstanceMethods
        # key is a way to 100% uniquely identify a user, even if token or secret change
        # "token" passed from provider
        # oauth "secret" passed from provider
        
        attr_accessor :authorize_url

        def authorize(callback_url, options = {})
          hash = self.class.authorize(callback_url, options)
          self.authorize_url = hash[:url]
          self.token         = hash[:token]
          self.secret        = hash[:secret]
          hash
        end
        
        def access(options)
          options = {:token => self.token, :secret => self.secret}.merge(options)
          hash = self.class.access(options)
          self.key           = hash[:key]
          self.token         = hash[:token]
          self.secret        = hash[:secret]
          hash
        end
        
        def credentials
          self.class.credentials
        end
      end
    end
  end
end
