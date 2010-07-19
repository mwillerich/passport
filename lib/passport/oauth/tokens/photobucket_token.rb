# https://login.photobucket.com/developer/register
class PhotobucketToken < AccessToken
  
  settings "http://api.photobucket.com",
    :request_token_path => "/login/request",
    :authorize_url      => "http://photobucket.com/apilogin/login",
    :access_token_path  => "/login/access"
  
  key "Username"
  
end
