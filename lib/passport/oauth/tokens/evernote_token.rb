# http://www.evernote.com/about/developer/api/evernote-api.htm
class EvernoteToken < OauthToken
  
  settings "https://www.evernote.com",
    :request_token_path => "/oauth",
    :authorize_path     => "/OAuth.action",
    :access_token_path  => "/oauth"
  
  key :edam_shard
end
