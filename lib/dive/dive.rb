require 'dive/version'

module Dive
  
  module Core
    
    def self.included clazz
      clazz.send :alias_method, :old_access, :[]
    end
  
    def dive location
      value = indifferent_access location 
      default?(value) ? dive_if_possible(location) : value
    end
    
    private
    
    def indifferent_access key
      value = old_access key
      default?(value) && key.respond_to?(:to_sym) ? old_access(key.to_sym) : value 
    end
    
    def default? value
      value == default
    end
    
    def dive_if_possible location
      matches = location.to_s.match /([^\[\]]*)\[(.*)\]/
      matches ? dive_deep(matches[1].strip, matches[2].strip) : default
    end
    
    def dive_deep key, remainder
      value = indifferent_access key
      value.respond_to?(:dive) ? value.dive(remainder) : default
    end
  end
  
  module Extensions
    def self.included clazz
      clazz.send :alias_method, :[], :dive
    end
  end
end