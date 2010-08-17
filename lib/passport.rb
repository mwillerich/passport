require 'rubygems'
require 'active_support'
require 'rack'
require 'json'
require 'oauth'
require 'oauth2'

this = File.expand_path(File.dirname(__FILE__))
library = "#{this}/passport"

Dir["#{library}/helpers/*"].each { |file| require file }
Dir["#{library}/core/*"].each { |file| require file }

require "#{library}/openid/protocol"
require "#{library}/engine" if defined?(Rails) && Rails::VERSION::MAJOR == 3

# require "#{library}/openid"
require "#{library}/passport"

Passport.root = "#{this}/.."