require "rubygems"
require 'active_record'
require 'oauth'
require 'oauth2'

this = File.dirname(__FILE__)
library = "#{this}/passport"
core = "#{library}/core"

require "#{library}/openid/protocol"
require "#{core}/rack-context"
require "#{core}/ext"
require "#{core}/settings"
require "#{core}/context"
require "#{core}/certification"
require "#{core}/user"
require "#{core}/mixin"
require "#{core}/filter"
# require "#{library}/openid"
require "#{library}/passport"
require "#{library}/oauth"
require "#{core}/engine" if defined?(Rails) && Rails::VERSION::MAJOR == 3

custom_models = ["#{library}/oauth/access_token"] + Dir["#{library}/oauth/tokens"]
#custom_models +=  Dir["#{library}/openid/tokens"]

# Rails 3/2 config
load_path_method = ActiveSupport::Dependencies.respond_to?(:autoload_paths) ? :autoload_paths : :load_paths

custom_models.each do |path|
  $LOAD_PATH << path
  ActiveSupport::Dependencies.send(load_path_method) << path
end

# Rails 3beta4 backport
if defined?(ActiveSupport::HashWithIndifferentAccess)
  ActiveSupport::HashWithIndifferentAccess.class_eval do
    def symbolize_keys!
      symbolize_keys
    end
  end
end