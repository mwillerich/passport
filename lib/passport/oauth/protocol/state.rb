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
          params? && session? && !token.blank?
        end
        alias complete? response?

        def active?
          request? || response?
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
