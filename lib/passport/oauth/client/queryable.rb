module Passport
  module Oauth
    module Queryable
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        # if we're lucky we can find it by the token.
        def find_by_key_or_token(key, token, options = {})
          result = self.find_by_key(key, options) unless key.nil?
          unless result
            if !token.blank? && self.respond_to?(:find_by_token)
              result = self.find_by_token(token, options)
            end
          end
          result 
        end
        
        def find_or_create_from_protocol(user, options = {})
          hash = access(options)
          unless token = find_by_key_or_token(hash[:key], hash[:secret], :include => [:user])
            token = new(hash)
          end
          token
        end
      end
      
      module InstanceMethods
        
      end
    end
  end
end
