class XeroToken < OauthToken
  
  settings "https://api.xero.com",
    :request_token_path => "/oauth/RequestToken",
    :authorize_path     => "/oauth/Authorize",
    :access_token_path  => "/oauth/AccessToken"
  
end
