module Passport
  module Certification
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def process?
        Passport::Oauth::Protocol.request?# || Passport::OpenId::Protocol.start?
      end
      alias start? process?
    
      def process(user)
        protocol.process(user) if protocol
      end
      alias start process
      
      def approve?
        Passport::Oauth::Protocol.response? # || Passport::OpenId::Protocol.complete?
      end
      alias complete? approve?
      
      def approve(user)
        protocol.approve(user) if protocol
      end
      alias complete approve
      
      def protocol
        if Passport::Oauth::Protocol.active?
          Passport::Oauth::Protocol
        # elsif Passport::OpenId::Protocol.using?
          #Passport::OpenId::Protocol
        end
      end
    end
  end
end
