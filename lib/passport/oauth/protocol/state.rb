module Passport
  module Oauth
    module State
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        def request?
          params? && provider? && !response?
        end
        alias start? request?
        
        def response?
          params? && session? && token?
        end
        alias complete? response?
        
        def active?
          request? || response?
        end
        
        def params?
          super && key?(:oauth_provider)
        end
        
        def token?
          provider? && !token.blank?
        end
        
        def provider?
          !provider.blank?
        end
        
        def auto_register?
          true
        end
      end
      
      module InstanceMethods
        
      end
    end
  end
end
