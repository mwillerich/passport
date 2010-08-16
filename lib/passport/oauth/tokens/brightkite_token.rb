# http://brightkite.com/me/developed_apps/new
# http://brightkite.com/me.xml (or .json)
class BrightkiteToken < OauthToken
  
  settings "http://brightkite.com"
  
  key do |access_token|
    JSON.parse(access_token.get("http://brightkite.com/me.json"))["id"]
  end
  
end
