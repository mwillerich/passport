module Rack
  class Context
    def initialize(app)
      @app = app
    end
    
    def call(env)
      Thread.current[:rack_context] = Rack::Request.new(env)
      @app.call(env)
    end
    
    class << self
      def request
        Thread.current[:rack_context]
      end
      
      def session
        request.nil? ? nil : request.session
      end
      
      def params
        request.nil? ? nil : request.params
      end
      
      def env
        request.nil? ? nil : request.env
      end
      
      def find(key)
        params_key(key) || session_key(key)
      end
      
      def session_key(key)
        return nil if session.blank?
        string = key.to_s
        symbol = key.to_sym
        return session[string] unless session[string].blank?
        return session[symbol] unless session[symbol].blank?
      end
      
      def params_key(key)
        return nil if params.blank?
        string = key.to_s
        symbol = key.to_sym
        return params[string] unless params[string].blank?
        return params[symbol] unless params[symbol].blank?
      end
      
      def find_pair(attribute)
        
      end
      
      def delete_session_key(key)
        keys = key.is_a?(Symbol) ? [key, key.to_s] : [key, key.to_sym]
        keys.each { |k| session.delete(k) }
      end
    end
  end
end
