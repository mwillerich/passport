module Passport
  module Oauth
    module Record
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        # this gives you the final key and secret that we will store in the database
        def find_or_create_token
          hash = token_class.access(
            :token          => request_token,
            :secret         => request_secret,
            :oauth_verifier => verifier,
            :callback_url   => callback_url
          )
          if token.respond_to?(:find_by_key_or_token)
            token = token_class.find_by_key_or_token(hash[:key], hash[:token])
          end
          token ||= token_class.new(hash)
          token
        end
        
        def store(record)
          session[:auth_attributes] = record.attributes.reject! do |k, v|
            v.blank? || !record.respond_to?(k)
          end if record.respond_to?(:attributes)
        end
        
        # restore attributes
        def restore(record)
          record.attributes = session.delete(:auth_attributes) if record.respond_to?(:attributes)
        end
      end
      
      module InstanceMethods
        
      end
    end
  end
end
