
begin
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
rescue ArgumentError
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
end

ActiveRecord::Base.configurations = true

# this schema was directly copied from 
# http://github.com/viatropos/authlogic-connect-example/blob/master/db/schema.rb
ActiveRecord::Schema.define(:version => 1) do
  
  create_table :access_tokens do |t|
    t.integer :user_id
    t.string :type, :limit => 30
    t.string :key # how we identify the user, in case they logout and log back in
    t.string :token, :limit => 1024 # This has to be huge because of Yahoo's excessively large tokens
    t.string :secret
    t.boolean :active # whether or not it's associated with the account
    t.timestamps
  end
  
  create_table :users, :force => true do |t|
    t.string   :login
    t.string   :email
    t.timestamps
  end

end
