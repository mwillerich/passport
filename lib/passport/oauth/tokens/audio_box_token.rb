# http://audiobox.fm
# http://audiobox.fm/pages/oauth
class AudioBoxToken < OauthToken
  
  settings "https://audiobox.fm"
  
  key do |access_token|
    JSON.parse(access_token.get("/api/user.json").body)
  end
  
end
