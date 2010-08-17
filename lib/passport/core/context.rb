module Passport
  module Context
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def find(key)
        Rack::Context.find(key)
      end
      
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
      
      def redirect(url)
        if controller = Thread.current[:rails_context]
          controller.redirect_to(url)
        else
          response = Rack::Response.new
          response.redirect(url)
          response.finish
        end
      end
      
      # if we've said it's a "user" (registration), or a "session" (login)
      def authentication_type
        find(:authentication_type)
      end
      
      def authentication_method
        find(:authentication_method)
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
      
      def debug
        puts "=== BEGIN DEBUG ==="
        puts "Passport.process? #{Passport.process?}"
        puts "Passport::Oauth::Protocol.request? #{Passport::Oauth::Protocol.request?.inspect}"
        puts "Passport::Oauth::Protocol.params? #{Passport::Oauth::Protocol.params?.inspect}"
        puts "Passport::Oauth::Protocol.provider? #{Passport::Oauth::Protocol.provider?.inspect}"
        puts "Passport::Oauth::Protocol.response? #{Passport::Oauth::Protocol.response?.inspect}"
        puts "Passport::Oauth::Protocol.session? #{Passport::Oauth::Protocol.session?.inspect}"
        puts "Passport::Oauth::Protocol.token? #{Passport::Oauth::Protocol.token?.inspect}"
        puts "Session #{session.inspect}"
        puts "Params #{params.inspect}"
        puts "=== END DEBUG ==="
      end
    end
  end
end
