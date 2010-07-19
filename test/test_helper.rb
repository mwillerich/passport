require "rubygems"
require "ruby-debug"
gem 'test-unit'
require "test/unit"
require 'active_support'
require 'active_support/test_case'
require "active_record"
require "active_record/fixtures"
require 'action_controller'
require 'shoulda'
require 'rr'
gem 'rack-test'
require 'rack/test'

require File.dirname(__FILE__) + '/dummy/database'
require File.dirname(__FILE__) + '/../lib/passport' unless defined?(Passport)
require File.dirname(__FILE__) + '/dummy/user'
require File.dirname(__FILE__) + '/dummy/app'
require File.dirname(__FILE__) + '/dummy/stubs'

# A temporary fix to bring active record errors up to speed with rails edge.
# I need to remove this once the new gem is released. This is only here so my tests pass.
unless defined?(::ActiveModel)
  class ActiveRecord::Errors
    def [](key)
      value = on(key)
      value.is_a?(Array) ? value : [value].compact
    end
  end
end

Passport.config = {
  :default => "twitter",
  :connect => {
    :twitter => {
      :key => "app_key",
      :secret => "app_secret",
      :headers => {
        "User-Agent" => "Safari",
        "MyApp-Version" => "1.2"
      },
      :api_version => 1
    },
    :facebook => {
      :key => "app_key",
      :secret => "app_secret"
    },
    :foursquare => {
      :key => "app_key",
      :secret => "app_secret"
    },
    :google => {
      :key => "app_key",
      :secret => "app_secret"
    },
    :yahoo => {
      :key => "app_key",
      :secret => "app_secret"
    },
    :vimeo => {
  
    }
  }
}

class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  include Rack::Test::Methods
  include RR::Adapters::TestUnit
  include Passport::Stubs::Oauth
  
  self.fixture_path = File.dirname(__FILE__) + "/fixtures"
  self.use_transactional_fixtures = false
  self.use_instantiated_fixtures  = false
  self.pre_loaded_fixtures = false
  fixtures :all
  
  def app
    Sinatra::Application
  end
  
end
