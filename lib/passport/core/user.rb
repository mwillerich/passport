module Passport
  module User
    def self.included(base)
      base.extend ClassMethods
      base.validate :validate_passport
      base.has_many :access_tokens, :class_name => "AccessToken", :dependent => :destroy
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
      
    end
    
    module InstanceMethods
      
      def save(&block)
        result = super
        yield(result) if block_given? && Passport.approve?
        result
      end
      
      def validate_passport
        if Passport.process?
          Passport.process(self) # redirect to service
        elsif Passport.approve?
          if token = Passport.approve(self)
            access_tokens << token
          else
            errors.add("Passport validation error")
          end
        end
      end
    end
  end
end
