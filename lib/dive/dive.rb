require 'dive/version'

module Dive
  
  module Core
    
    def self.included clazz
      clazz.send :alias_method, :old_access, :[]
    end
  
    def dive location
      value = old_access(location)
      value == default ? dive_deep(location) : value
    end
    
    private
    
    def dive_deep location
      matches = location.to_s.match /([^\[\]]*)\[(.*)\]/
      return default unless matches
      key, remainder = matches[1], matches[2]
      value = old_access key
      value.respond_to?(:dive) ? value.dive(remainder) : default
    end
  end
  
  module Extensions
    def self.included clazz
      clazz.send :alias_method, :[], :dive
    end
  end
end