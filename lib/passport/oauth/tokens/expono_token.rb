class ExponoToken < OauthToken
  
  settings "http://www.expono.com",
    :request_token_path => "/go/oauth/request_token",
    :authorize_path     => "/go/oauth/authorize",
    :access_token_path  => "/go/oauth/access_token"
    
  key "userid"
  
end
