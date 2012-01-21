require 'dive/version'

module Dive
  
  def self.included clazz
    clazz.send :include, Read
    clazz.send :include, Write
  end
  
  def as_symbol key
    key_string = key.to_s
    (key_string[0, 1] == ':') ? key_string[1..-1].to_sym : key
  end
  
  def symbolise key
    key.is_a?(Symbol) ? key : as_symbol(key)
  end
  
  def split_dive location
    location.to_s.match /^([^\[\]]+)\[(.+)\]\s*$/ #(key)[(remainder)]
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
      split_location = split_dive location
      split_location ? dive_to_next_level(split_location[1].strip, split_location[2].strip) : default_value(location)
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
      split_location = split_dive location
      split_location ? store_at_next_level(split_location[1], split_location[2], value) : old_store(symbolise(location), value)
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