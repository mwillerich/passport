# http://developer.cliqset.com/api#TOC-OAuth-2.0-Overview
# http://developer.cliqset.com/api/user
class CliqsetToken < AccessToken
  
  settings "https://secure.cliqset.com",
    :authorize_path     => "/oauth/v2/authorize",
    :access_token_path  => "/oauth/v2/access_token"
    
  key do |access_token|
    JSON.parse(access_token.get("https://api.cliqset.com/v4/user/me"))["User"]["ID"]
  end
  
end
