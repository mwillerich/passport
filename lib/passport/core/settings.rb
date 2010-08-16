module Passport
  class SettingsError < StandardError; end
    
  module Settings
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      KEY = "connect" unless defined?(KEY)
      
      attr_accessor :config
      
      def configure(value)
        self.config = (value.is_a?(String) ? YAML.load_file(value) : value).recursively_symbolize_keys!
      end
      
      def key(path)
        result = self.config
        path.to_s.split(".").each { |node| result = result[node.to_sym] if result }
        result
      end
      
      def credentials(service)
        result = key("#{KEY}.#{service.to_s}")
        unless result && result.has_key?(:key) && result.has_key?(:secret)
          raise SettingsError.new("Please specify both a key and secret for ':#{service}'")
        end
        result
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
