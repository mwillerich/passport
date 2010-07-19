module Passport
  module Oauth
    module Consumable
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        def consumer_settings(options = {})
          settings.merge(credentials[:options] || {}).merge(options)
        end
        
        def access_token(token, secret, version = 1.0, options = {})
          if version == 1.0
            OAuth::AccessToken.new(consumer, token, secret)
          else
            OAuth2::AccessToken.new(consumer, token)
          end
        end
        
        def consumer(options = {})
          if version == 1.0
            OAuth::Consumer.new(credentials[:key], credentials[:secret], consumer_settings(options))
          else
            OAuth2::Client.new(credentials[:key], credentials[:secret], consumer_settings(options))
          end
        end
      end
      
      module InstanceMethods
        def access_token
          @access_token ||= self.class.access_token(token, secret)
          @access_token
        end
        
        def consumer(options = {})
          self.class.consumer(options)
        end
        
        def clear
          @access_token = nil
        end
      end
    end
  end
end
