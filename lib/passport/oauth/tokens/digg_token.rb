# http://digg.com/api/docs/authentication
class DiggToken < OauthToken
  
  settings "http://digg.com",
    :authorize_path => "/oauth/authenticate",
    :request_token_url => "http://services.digg.com/1.0/endpoint?method=oauth.getRequestToken",
    :access_token_url  => "http://services.digg.com/1.0/endpoint?method=oauth.getAccessToken"
  
end
