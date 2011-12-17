require 'dive/version'

module Dive
  
  module Core
    
    def self.included clazz
      clazz.send :alias_method, :old_access, :[]
    end
  
    def dive location
      value = old_access(location)
      value = old_access(location.to_sym) if default?(value) && location.respond_to?(:to_sym)
      default?(value) ? dive_deep(location) : value
    end
    
    private
    
    def default? value
      value == default
    end
    
    def dive_deep location
      matches = location.to_s.match /([^\[\]]*)\[(.*)\]/
      return default unless matches
      key, remainder = matches[1].strip, matches[2].strip
      value = old_access key
      value = old_access(key.to_sym) if default?(value) && key.respond_to?(:to_sym)
      value.respond_to?(:dive) ? value.dive(remainder) : default
    end
  end
  
  module Extensions
    def self.included clazz
      clazz.send :alias_method, :[], :dive
    end
  end
end