# http://www.agentstorm.com/
# http://groups.google.com/group/agentstorm-api/
# http://www.agentstorm.com/blog/
class AgentStormToken < OauthToken
  
  # replace "acme" with user
  settings "http://acme.agentstorm.com",
    :request_token_path => "/session/oAuthRequestToken",
    :authorize_path     => "/session/oAuthAuthorize",
    :access_token_path  => "/session/oAuthAccessToken"
  
end
