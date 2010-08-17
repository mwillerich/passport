module Passport
  module Installation
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      attr_accessor :installed
      
      def install
        return if installed
        
        require "#{root}/lib/passport/support/#{adapter}"
        require "#{root}/lib/passport/oauth"
        
        if defined?(Rails)          
          custom_models = ["#{root}/lib/passport/support/#{adapter}"] + Dir["#{root}/lib/passport/oauth/tokens"]
          #custom_models +=  Dir["#{library}/openid/tokens"]
          
          # Rails 3/2 config
          load_path_method = ActiveSupport::Dependencies.respond_to?(:autoload_paths) ? :autoload_paths : :load_paths
          
          custom_models.each do |path|
            $LOAD_PATH << path
            ActiveSupport::Dependencies.send(load_path_method) << path
          end
        end
        
        # Rails 3beta4 backport
        if defined?(ActiveSupport::HashWithIndifferentAccess)
          ActiveSupport::HashWithIndifferentAccess.class_eval do
            def symbolize_keys!
              symbolize_keys
            end
          end
        end
        
        if defined?(ActionController::Base)
          ActionController::Base.helper(Passport::Oauth::ViewHelper)
        end
        if defined?(ActionView::Helpers::FormBuilder)
          ActionView::Helpers::FormBuilder.send(:include, Passport::Oauth::ViewHelper)
        end
        
        installed = true
      end
    end
  end
end
