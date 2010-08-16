require "rubygems"
require 'active_record'
require 'oauth'
require 'oauth2'

this = File.expand_path(File.dirname(__FILE__))
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

Passport.root = this