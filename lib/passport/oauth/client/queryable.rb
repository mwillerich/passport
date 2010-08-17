module Passport
  module Oauth
    module Queryable
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        # if we're lucky we can find it by the token.
        def find_by_key_or_token(key, token)
          result = self.find_by_key(key) unless key.nil?
          result = self.find_by_token(token) if !(result && token.blank?)
          result 
        end
      end
      
      module InstanceMethods
        
      end
    end
  end
end
