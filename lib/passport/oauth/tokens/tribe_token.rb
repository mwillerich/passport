# http://tribehr.com/support/api/oauth/
class TribeToken < OauthToken
  
  settings "http://acme.mytribehr.com",
    :request_token_path => "/oauth_rest/server/requestToken",
    :authorize_path     => "/oauth_rest/server/authorize",
    :access_token_path  => "/oauth_rest/server/accessToken"
  
end
