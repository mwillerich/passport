# protocol = Protocol.new(twitter_client, app_key, app_secret)
# protocol.authorize("http://localhost:3000/authenticate") #=> hash
# protocol.access #=> hash
class OauthToken < AccessToken
  include Passport::Oauth::Defineable
  include Passport::Oauth::Consumable
  include Passport::Oauth::Authorizable
  include Passport::Oauth::Restful
  include Passport::Oauth::Queryable
end
