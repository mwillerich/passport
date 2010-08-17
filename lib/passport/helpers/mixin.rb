module Passport
  module Mixin
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def has_passport
        include Passport::User
      end
    end
  end
end

ActiveRecord::Base.send(:include, Passport::Mixin) if defined?(ActiveRecord::Base)
