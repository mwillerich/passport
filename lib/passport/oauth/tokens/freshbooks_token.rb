# http://developers.freshbooks.com/api/oauth/
# http://github.com/elucid/ruby-freshbooks
class FreshbooksToken < OauthToken
  
  # only PLAINTEXT is supported
  settings "https://sample.freshbooks.com",
    :request_token_path => "/oauth/oauth_request.php",
    :authorize_path     => "/oauth/oauth_authorize.php",
    :access_token_path  => "/oauth/oauth_access.php",
    :oauth_signature_method => "PLAINTEXT"
  
end
