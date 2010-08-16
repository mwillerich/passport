module Passport
  module Context
    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
      def session
        Rack::Context.session
      end
      
      def session_key(key)
        Rack::Context.session_key(key)
      end
      
      def params
        Rack::Context.params
      end
      
      def params_key(key)
        Rack::Context.params_key(key)
      end
      
      def find(key)
        Rack::Context.find(key)
      end
      
      def redirect(url)
        response = Rack::Response.new
        response.redirect(url)
        response.finish
      end
      
      # if we've said it's a "user" (registration), or a "session" (login)
      def authentication_type
        find(:authentication_type)
      end
      
      def authentication_method
        find(:authentication_method)
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
      
      def clear
        [:auth_request_class,
          :authentication_type,
          :auth_method,
          :auth_attributes,
          :oauth_provider,
          :auth_callback_method
        ].each { |key| Rack::Context.delete_session_key(key) }
      end
    end
    
    module InstanceMethods
      
    end
  end
end
