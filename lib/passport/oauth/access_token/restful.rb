module Passport
  module Oauth
    module Restful
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        
      end
      
      module InstanceMethods
        def get(path, headers = {})
          access_token.get(path, headers)
        end
        
        def post(path, body = "", headers = {})
          access_token.post(path, body, headers)
        end

        def head(path, headers = {})
          access_token.head(path, headers)
        end

        def put(path, body = "", headers = {})
          access_token.put(path, body, headers)
        end

        def delete(path, headers = {})
          access_token.delete(path, headers)
        end
      end
    end
  end
end
