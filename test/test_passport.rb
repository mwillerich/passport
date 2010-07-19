require File.dirname(__FILE__) + '/test_helper.rb'

module Passport
  class PassportTest < ActiveSupport::TestCase
      
    context "Passport context" do
      setup do
        get '/', :authentication_type => "user"
      end
      
      should "have an authentication type in the session" do
        assert last_response.ok?
        assert_equal 'Hello World', last_response.body
        assert_equal "user", Passport.authentication_type
      end
      
      should "be able to clear the authentication_type" do
        Passport.clear
        assert_equal nil, Passport.authentication_type
      end
      
      teardown do
        Passport.clear
      end
    end
    
  end
end
