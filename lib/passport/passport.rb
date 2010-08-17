module Passport
  include Passport::Settings
  include Passport::Context
  include Passport::State
  include Passport::Certification
  include Passport::Installation
end

module Rack
  class Passport
    attr_accessor :middleware
    
    def initialize(app)
      @app = app
      self.middleware = [::Rack::Context.new(app), ::Passport::Filter.new(app)]
    end
    
    def call(env)
      self.middleware.each { |ware| ware.call(env) }
      @app.call(env)
    end
  end
end
