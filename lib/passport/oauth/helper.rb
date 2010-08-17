module Passport
  module Oauth
    module ViewHelper
      def oauth_register_hidden_input
        oauth_input(:type => "user")
      end
  
      def oauth_login_hidden_input
        oauth_input(:type => "session")
      end
  
      def oauth_input(options = {})
        tag(:input, :type => "hidden", :name => "authentication_type", :value => options[:type])
      end
    end
  end
end

