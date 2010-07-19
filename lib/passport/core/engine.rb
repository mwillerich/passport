module Passport
  class Engine < Rails::Engine
    
    initializer "passport.authentication_hook" do |app|
      app.middleware.use Rack::Context
      app.middleware.use Passport::Filter
      app.middleware.use OpenIdAuthentication
    end
    
    initializer "passport.finalize", :after => "passport.authentication_hook" do |app|
      OpenID::Util.logger = Rails.logger
      ActionController::Base.send :include, OpenIdAuthentication
    end
  end
end
