module Passport
  module Oauth
    module Defineable
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
      
      module ClassMethods
      
        def service_name
          @service_name ||= self.to_s.underscore.scan(/^(.*?)(_token)?$/)[0][0].to_s
        end
        
        # oauth version, 1.0 or 2.0, should be a float b/c we may encounter 1.1 for example.
        def version(value = nil)
          @version = value if value
          @version ||= 1.0
          @version
        end

        # unique key that we will use from the AccessToken response
        # to identify the user by.
        # in Twitter, its "user_id".  Twitter has "screen_name", but that's
        # more subject to change than user_id.  Pick whatever is least likely to change
        def key(value = nil, &block)
          if block_given?
            @key = block
          elsif value
            @key = value.is_a?(Symbol) ? value : value.to_sym
          end

          @key
        end

        def settings(site = nil, hash = {})
          @settings = hash.merge(:site => site) if site
          @settings
        end
        
        def setting(key)
          settings ? settings[key.to_sym] : ""
        end        
        
        # this is a method used to identify the user uniquely from the oauth protocol
        def identify(access_token)
          if key
            if key.is_a?(Proc)
              return key.call(access_token)
            else
              return (access_token.params[key.to_s] || access_token.params[key.to_sym]) # try both
            end
          else
            raise "please set an oauth key for #{service_name.to_s}"
          end
        end
      end
      
      module InstanceMethods
        def version
          self.class.version
        end
        
        def settings
          self.class.settings
        end
        
        def setting(key)
          self.class.setting(key)
        end
        
        def identify
          self.class.identify(access_token)
        end
      end
    end
  end
end
