class SalesforceToken < OauthToken
  
  settings "https://login.salesforce.com",
    :request_token_url => "https://login.salesforce.com/_nc_external/system/security/oauth/RequestTokenHandler",
    :access_token_url  => "https://login.salesforce.com/_nc_external/system/security/oauth/AccessTokenHandler",
    :authorize_url     => "https://login.salesforce.com/setup/secur/RemoteAccessAuthorizationPage.apexp",
    :scheme            => :body
  
end
