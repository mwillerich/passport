# http://wiki.smugmug.net/display/API/OAuth
# http://wiki.smugmug.net/display/API/smugmug.auth.getAccessToken+1.2.2
class SmugMugToken < OauthToken
  
  settings "http://api.smugmug.com",
    :request_token_path => "/services/oauth/getRequestToken.mg",
    :authorize_path     => "/services/oauth/authorize.mg",
    :access_token_path  => "/services/oauth/getAccessToken.mg"
    
  key "User::id"
  
end
