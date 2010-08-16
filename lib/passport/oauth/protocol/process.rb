module Passport
  module Oauth
    module Process
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        def process(record)
          authorize_hash = token_class.authorize(callback_url)
          
          session[:oauth_request_token]        = authorize_hash[:token]
          session[:oauth_request_token_secret] = authorize_hash[:secret]
          session[:auth_request_class]         = record.class.name
          session[:authentication_type]        = params["authentication_type"]
          session[:oauth_provider]             = params["oauth_provider"]
          session[:auth_method]                = "oauth"
          session[:auth_callback_method]       = "create"# controller.request.method

          store(record)
          
          redirect authorize_hash[:url]
        end
        alias start process
        
        def approve(record)
          return nil if !complete?
          restore(record)
          token = find_or_create_token(record)
          clear
          token
        end
        alias complete approve
        
        # Step last, after the response
        # having lots of trouble testing logging and out multiple times,
        # so there needs to be a solid way to know when a user has messed up loggin in.
        def clear
          [:auth_request_class,
            :authentication_type,
            :auth_method,
            :auth_attributes,
            :oauth_provider,
            :auth_callback_method,
            :oauth_request_token,
            :oauth_request_token_secret
          ].each { |key| session.delete(key) }
        end
      end
      
      module InstanceMethods
        
      end
    end
  end
end
