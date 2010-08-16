# http://www.freebase.com/docs/acre/oauth
class FreebaseToken < OauthToken
  
  settings "https://www.freebase.com",
    :request_token_path => "/api/oauth/request_token",
    :access_token_path  => "/api/oauth/access_token",
    :authorize_path     => "/signin/authorize_token"
  
end
