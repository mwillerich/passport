module Passport
  module Oauth
    module Process
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
        def process(record = nil)
          authorize_hash = token_class.authorize(callback_url)
          
          session[:oauth_request_token]        = authorize_hash[:token]
          session[:oauth_request_token_secret] = authorize_hash[:secret]
          session[:auth_request_class]         = record.class.name if record
          session[:authentication_type]        = params["authentication_type"]
          session[:oauth_provider]             = params["oauth_provider"]
          session[:auth_method]                = "oauth"
          session[:auth_callback_method]       = "post"# controller.request.method

          store(record) if record
          
          redirect authorize_hash[:url]
        end
        alias start process
        
        def approve(record)
          return nil if !complete?
          restore(record) if record
          token = find_or_create_token
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
          ].each do |key|
            Rack::Context.delete_session_key(key)
          end
        end
      end
      
      module InstanceMethods
        
      end
    end
  end
end
