module Passport
  module State
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def key?(key)
        Rack::Context.key?(key)
      end
      
      def session_key?(key)
        Rack::Context.session_key?(key)
      end
      
      def params_key?(key)
        Rack::Context.params_key?(key)
      end
      
      def params?
        !params.blank?
      end
      
      def session?
        !session.blank?
      end
      
      def active?
        Passport::Oauth::Protocol.active? || Passport::Oauth::Protocol.active?
      end
      
      def authenticating?(type)
        authentication_type == type.to_s
      end
    end
  end
end
