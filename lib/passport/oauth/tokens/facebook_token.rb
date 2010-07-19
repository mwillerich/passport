# http://www.facebook.com/developers/apps.php
# http://developers.facebook.com/setup/
class FacebookToken < OauthToken
  
  version 2.0
  
  key do |access_token|
    user = JSON.parse(access_token.get("/me"))
    user["id"]
  end
  
  settings "https://graph.facebook.com",
    :authorize_url => "https://graph.facebook.com/oauth/authorize",
    :scope         => "email, offline_access"
  
end
