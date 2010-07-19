# Passport (ActiveExchange)

> Oauth and OpenId made Dead Simple

Passport is your single interface to Oauth 1.0, Oauth 2.0, and OpenID.

Allow your users to login with Github, Facebook, Twitter, Google, LinkedIn, MySpace, Vimeo, and Yahoo Oauth providers, and all the OpenID providers.  Simple, Clean, Fast.

## Install

### 1. Install Passport

    sudo gem install passport

### 2. Add the gem dependencies in your config:

Rails 2.3.x: `config/environment.rb`

    config.gem "passport"

Rails 3: `Gemfile`

    gem "passport"
    
### 3.  Add the OpenIdAuthentication.store

Do to [some strange problem](http://github.com/openid/ruby-openid/issues#issue/1) I have yet to really understand, Rails 2.3.5 doesn't like when `OpenIdAuthentication.store` is null, which means it uses the "in memory" store and for some reason fails.

So as a fix, if you are using Rails < 3, add these at the end of your `config/environment.rb` files:

In development mode:

    OpenIdAuthentication.store = :file
    
In production (on Heroku primarily)

    OpenIdAuthentication.store = :memcache

### 4. Add the Migrations

See the [Rails 2 Example](http://github.com/viatropos/passport-connect-example-rails2) and [Rails 3 Example](http://github.com/viatropos/passport-connect-example) projects to see what you need.  Will add a generator sometime.

Files needed are:

- models: User, UserSession
- controllers: UsersController, UserSessionsController, ApplicationController
- migrations: create\_users, create\_sessions, create\_tokens
- initializers: config/passport.example.yml, config/initializers/passport_connect_config.rb
- routes
    
### 5. Configure your keys

In `config/passport.yml`, write your keys and secrets for each service you would like to support.  You have to manually go to the websites and register with the service provider (list of those links coming soon, in token classes for now).

    connect:
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

    Passport.config = YAML.load_file("config/passport.yml")

### Lists of known providers:

- [Oauth Providers](http://wiki.oauth.net/ServiceProviders)
- [More Oauth Providers](http://www.programmableweb.com/apis/directory/1?auth=OAuth)
- [OpenID Providers](http://en.wikipedia.org/wiki/List_of_OpenID_providers)
- [More OpenID Providers](http://openid.net/get-an-openid/)

- 2 ways to handle oauth/openid
  1. go through controller twice, using a block as a filter.
  2. handle the redirect automatically in Rack, only go to controller after redirect.