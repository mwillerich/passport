# http://friendfeed.com/api/documentation#installed_app_auth
class FriendfeedToken < OauthToken
  
  settings "https://friendfeed.com/account/oauth",
    :access_token_path => "/ia_access_token"
  
end
