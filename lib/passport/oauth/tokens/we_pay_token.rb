# https://www.wepay.com/developer/oauth
# https://www.wepay.com/developer/reference
class WePayToken < OauthToken
  
  settings "https://wepayapi.com/v1",
    :authorize_url => "https://www.wepay.com/session/authorize"
  
end
