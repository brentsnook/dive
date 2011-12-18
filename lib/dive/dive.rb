require 'dive/version'

module Dive
  
  module Read
    
    def self.included clazz
      clazz.send :alias_method, :old_access, :[]
    end
  
    def dive location
      has_key?(location) ? old_access(location) : dive_access(location)
    end
    
    private
    
    def dive_access location
      has_key?(symbolise(location)) ? blah_access(symbolise(location)) : dive_if_possible(location)
    end
    
    def blah_access location
      old_access symbolise(location)
    end
    
    def symbolise key
      is_symbol = key.respond_to?(:to_sym) && key[0] == ':'
      is_symbol ? key[1..-1].to_sym : key
    end
    
    def default_value key
      default_proc ? default_proc.call(self, key) : default
    end 
    
    def dive_if_possible location
      matches = location.to_s.match /([^\[\]]*)\[(.*)\]/
      matches ? dive_deep(matches[1].strip, matches[2].strip) : default_value(location)
    end
    
    def dive_deep key, remainder
      value = blah_access key
      value.respond_to?(:dive) ? value.dive(remainder) : default_value(remainder)
    end
  end
  
  module Extensions
    def self.included clazz
      clazz.send :alias_method, :[], :dive
    end
  end
end