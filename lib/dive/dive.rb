require 'dive/version'

module Dive
  
  module Core
    
    def self.included clazz
      clazz.send :alias_method, :old_access, :[]
    end
  
    def dive location
      value = old_access(location) || (old_access(location.to_sym) if location.respond_to?(:to_sym))
      value || dive_deep(location)
    end
    
    private
  
    def dive_deep location
      matches = location.to_s.match /([^\[\]]*)\[(.*)\]/
      matches ? continue_dive(matches[1].strip, matches[2].strip) : nil
    end
  
    def continue_dive key, remainder
      value = old_access(key) || old_access(key.to_sym)
      value.dive(remainder) if value.respond_to?(:dive)
    end
  end
  
  module Extensions
    def self.included clazz
      clazz.send :alias_method, :[], :dive
    end
  end
end