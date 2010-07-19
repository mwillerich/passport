module Passport
  module Settings
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      KEY = "connect" unless defined?(KEY)
      
      attr_accessor :config
      
      def config=(value)
        value.recursively_symbolize_keys!
        @config = value
      end
      
      def key(path)
        result = self.config
        path.to_s.split(".").each { |node| result = result[node.to_sym] if result }
        result
      end
    
      def credentials(service)
        key("#{KEY}.#{service.to_s}")
      end
      
      def services
        key(KEY)
      end
    
      def service_names
        services.keys.collect(&:to_s)
      end
    
      def include?(service)
        !credentials(service).nil?
      end
      
      def token(key)
        raise "can't find key '#{key.to_s}' in Passport.config" unless Passport.include?(key) and !key.to_s.empty?
        "#{key.to_s.camelcase}Token".constantize
      end
      
      def consumer(key)
        token(key).consumer
      end
    end
  end
end
