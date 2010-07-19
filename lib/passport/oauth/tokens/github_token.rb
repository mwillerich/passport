# http://github.com/account/applications
class GithubToken < OauthToken
  
  version 2.0
  
  key do |access_token|
    response = JSON.parse(access_token.get("/api/v2/json/user/show"))
    response["user"]["id"]
  end
  
  settings "https://github.com",
    :authorize_path     => "/login/oauth/authorize",
    :access_token_path  => "/login/oauth/access_token"
  
end
