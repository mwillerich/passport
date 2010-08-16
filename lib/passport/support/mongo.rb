require 'mongo_mapper'
class AccessToken
  include MongoMapper::Document
  
  key :token
  key :secret
  key :key
  
end
