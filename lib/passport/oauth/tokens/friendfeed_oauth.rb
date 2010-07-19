# http://friendfeed.com/api/documentation#installed_app_auth
class FriendfeedToken < AccessToken
  
  settings "https://friendfeed.com/account/oauth",
    :access_token_path => "/ia_access_token"
  
end
