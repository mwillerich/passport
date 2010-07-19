# https://www.yammer.com/api_doc.html
class YammerToken < AccessToken

  settings "https://www.yammer.com"
  
  key do |access_token|
    JSON.parse(access_token.get("/api/v1/users/current.json"))["id"]
  end
  
end
