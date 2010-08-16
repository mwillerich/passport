# [Passport](http://authlogic-connect.heroku.com)

> Oauth and OpenId made Dead Simple.

Note: This is a refactoring and abstraction of [AuthlogicConnect](http://github.com/viatropos/authlogic-connect) and it is not complete yet.  The goal is to make it as low level as possible while still making it extremely simple to setup.  It will abstract away all Oauth/OpenID complexities and be pluggable into any existing authentication framework.

Passport is your single interface to Oauth 1.0, Oauth 2.0, and OpenID.

Allow your users to login with Github, Facebook, Twitter, Google, LinkedIn, MySpace, Vimeo, and Yahoo Oauth providers ([complete list](http://github.com/viatropos/passport/lib/passport/oauth/tokens)), and all the OpenID providers.  Simple, Clean, Fast.

## Usage

### 1. Install

    sudo gem install passport
    
### 2. Configure

#### Add the gem dependencies in your config

Rails 2.3.x: `config/environment.rb`

    config.gem "passport"

Rails 3: `Gemfile`

    gem "passport"

Ruby:

    require "passport"
    
#### Specify your keys and secrets

In a yaml file, say `config/passport.yml`, write your keys and secrets for each service you would like to support.  You have to manually go to the websites and register with the service provider.

    adapter: active_record
    services:
      twitter:
        key: "my_key"
        secret: "my_secret"
        label: "Twitter"
      facebook:
        key: "my_key"
        secret: "my_secret"
        label: "Facebook"
      google:
        key: "my_key"
        secret: "my_secret"
        label: "Google"
      yahoo:
        key: "my_key"
        secret: "my_secret"
        label: "Yahoo"
      myspace:
        key: "my_key"
        secret: "my_secret"
      vimeo:
        key: "my_key"
        secret: "my_secret"
      linked_in:
        key: "my_key"
        secret: "my_secret"
      
Then in your application's initialization process:
    
    Passport.configure("config/passport.yml")

## Adapters

In the `config/passport.yml`, you can specify an `adapter`.  The adapter tells Passport what kind of class we want the `AccessToken` to be.  The choices are:

- `object`
- `active_record`
- `mongo`

### Plain Ruby Objects

By default, if an `adapter` is not specified, `AccessToken` will be a plain-old Ruby [`Object`](http://ruby-doc.org/core/classes/Object.html).  This means the framework does not have any large dependencies by default, which is useful if you're making a quick and dirty Sinatra app for example, and just want super-simple Oauth support without a database.

### ActiveRecord

If you want to use this with ActiveRecord, you have to setup migrations.  Check out the [Rails 3 AuthlogicConnect example](http://github.com/viatropos/authlogic-connect-example) for an authlogic example with user/session/access_token migrations.  The migrations table we have been using so far look like this:

    class CreateAccessTokens < ActiveRecord::Migration
      def self.up
        create_table :access_tokens do |t|
          t.integer :user_id
          t.string :type, :limit => 30 #=> service as a class name
          t.string :key # how we identify the user, in case they logout and log back in (e.g. email)
          t.string :token, :limit => 1024
          t.string :secret
          t.boolean :active # whether or not it's associated with the account
          t.timestamps
        end
        
        add_index :access_tokens, :key, :unique
      end
      
      def self.down
        drop_table :access_tokens
      end
    end

### MongoDB

MongoDB doesn't require any migrations so it's a simple setup.  Just specify the mongo adapter in `config/passport.yml`:

    adapter: mongo
    
## API

There's a lot of functionality packed into Passport.  All you need to know is that every service out there (Facebook, Twitter, Github, Foursquare, etc.) is treated as a `Token`.  The `OauthToken` (most of this is Oauth right now) has these key methods and attributes:

- `Token.authorize(callback_url, headers)`: get the authorize url from the oauth provider
- `Token.access(hash)`: get the access token from the oauth provider
- `key`: the unique identifier for this user (optional, but definitely recommended)
- `token`: oauth token from service
- `secret`: oauth secret from service
- `get(url, options)`: authenticated api GET to the service; pass in headers, params, etc.
- `post(url, body, options)`: authenticated api POST to the service

This means that instead of having to [write lots of code](http://github.com/intridea/oauth2) to setup even a simple oauth handler in your app, you can do this (sinatra example):

    require 'rubygems'
    require 'passport'
    
    Passport.configure("tokens.yml")
    
    get "/" do
      "<a href='/authenticate?oauth_provider=facebook'>Login with Facebook</a>"
    end
    
    get "/authenticate" do
      Passport.authenticate
    end
    
This also means that if you wanted to do your own oauth setup, with or without any framework, you can easily do that.  Say you want to programmatically setup Facebook Oauth with Mechanize (!):

    def facebook_oauth
      authorize_hash = FacebookToken.authorize("http://some-real-or-fake-callback-url/")
      # mechanically submit forms
      access_hash    = FacebookToken.access(authorize_hash)
      # boom, you have the access token (token, key, and secret), now go exploring
    end
    
## Lists of known providers

- [Oauth Providers](http://wiki.oauth.net/ServiceProviders)
- [More Oauth Providers](http://www.programmableweb.com/apis/directory/1?auth=OAuth)
- [OpenID Providers](http://en.wikipedia.org/wiki/List_of_OpenID_providers)
- [More OpenID Providers](http://openid.net/get-an-openid/)

## Random Resources and Notes

- 2 ways to handle oauth/openid
  1. go through controller twice, using a block as a filter.
  2. handle the redirect automatically in Rack, only go to controller after redirect.
  
[Oauth/OpenID Recent Security Hole](http://status.net/2010/07/17/security-update-openid-oauth-library-issues): [Announcement](http://status.net/wiki/Security_alert_0000003)

- http://www.atutor.ca/transformable/demo/documentation/oauth_server_api.php
- http://github.com/jcrosby/cloudkit
- http://getcloudkit.com/
- http://docs.dossia.org/index.php/Dossia_OAuth_Developer_Guide
- http://developer.constantcontact.com/book/export/html/279
- http://microformats.org/wiki/RelMeAuth
- doodle oauth
- http://www.postrank.com/developers/api
- http://data.postrank.com/
- fireagle
- https://my.silentale.com/developers/apis/data
- http://www.moneybird.nl/help/api
- http://www.jaiku.com/
- tumbler
- http://shifd.com/developers
- http://tarpipe.com/developers/guide/api/2.0
- http://wiki.erepublik.com/index.php/ERepublik_API
- http://1daylater.com/the_api
- http://community.liveperson.com/docs/DOC-1033
- https://secure.lonelyplanet.com/sign-in/login?service=http%3A%2F%2Fapigateway.lonelyplanet.com%2Fdevelopers

Use forwardable to keep the AccessToken thin

- http://github.com/jrmey/oauth2_curl
- [Oauth 2 Spec](http://tools.ietf.org/html/draft-ietf-oauth-v2-10)
- [The Present Future of Oauth](http://assets.en.oreilly.com/1/event/40/The%20Present%20Future%20of%20OAuth%20Presentation.pdf)