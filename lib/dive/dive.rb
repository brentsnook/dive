require 'dive/version'

module Dive
  
  def self.included clazz
    clazz.send :include, Read
    clazz.send :include, Write
  end
  
  def symbolise key
    is_symbol = key.respond_to?(:to_sym) && key[0] == ':'
    is_symbol ? key[1..-1].to_sym : key
  end
    
  module Read
    
    def self.included clazz
      clazz.send :alias_method, :old_read, :[]
    end
  
    def dive location
      has_key?(location) ? old_read(location) : dive_read(location)
    end
    
    private
    
    def dive_read location
      has_key?(symbolise(location)) ? old_read(symbolise(location)) : attempt_dive(location)
    end
    
    def default_value key
      default_proc ? default_proc.call(self, key) : default
    end 
    
    def attempt_dive location
      matches = location.to_s.match /([^\[\]]*)\[(.*)\]/ #(key)[(remainder)]
      matches ? dive_to_next_level(matches[1].strip, matches[2].strip) : default_value(location)
    end
    
    def dive_to_next_level key, remainder
      value = old_read(symbolise(key))
      value.respond_to?(:dive) ? value.dive(remainder) : default_value(remainder)
    end
  end
  
  module Write
    
    def self.included clazz
      clazz.send :alias_method, :old_store, :[]=
    end
    
    def dive_store location, value
      matches = location.to_s.match /([^\[\]]*)\[(.*)\]/
      matches ? store_at_next_level(matches[1], matches[2], value): old_store(symbolise(location), value)
    end
    
    private
    
    def store_at_next_level(key, remainder, value)
      storer = has_key?(symbolise(key)) ? old_read(symbolise(key)) : {}
      old_store symbolise(key), storer
      storer.dive_store remainder, value
    end
    
  end
  
  module Extensions
    def self.included clazz
      clazz.send :alias_method, :[], :dive
      clazz.send :alias_method, :[]=, :dive_store
    end
  end
end