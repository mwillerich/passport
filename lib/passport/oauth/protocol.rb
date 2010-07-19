module Passport
  module Oauth
    class Protocol
      include Passport::Context
      include Passport::Oauth::Context
      include Passport::Oauth::State
      include Passport::Oauth::Record
      include Passport::Oauth::Process
    end
  end
end
