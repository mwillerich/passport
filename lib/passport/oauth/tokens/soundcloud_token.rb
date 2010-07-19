# http://github.com/soundcloud/oauth
class SoundcloudToken < AccessToken

  settings "http://api.soundcloud.com"
  
  key do |access_token|
    JSON.parse(access_token.get("/users/me"))["id"]
  end
  
end
