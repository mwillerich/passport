# http://gowalla.com/api/docs/oauth
class GowallaToken < OauthToken
  
  version 2.0
  
  settings "https://api.gowalla.com",
    :authorize_url    => "https://gowalla.com/api/oauth/new",
    :access_token_url => "https://gowalla.com/api/oauth/token"
    
  key :username
  
end
