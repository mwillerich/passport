module Passport
  module Oauth
    module Record
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        # this gives you the final key and secret that we will store in the database
        def find_or_create_token(record)
          token_class.find_or_create_from_protocol(
            record,
            :token          => request_token,
            :secret         => request_secret,
            :verifier       => verifier,
            :callback_url   => callback_url
          )
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
