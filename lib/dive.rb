require "dive/version"

module Dive
  
  def dive location
    value = self[location] || self[location.to_sym]
    value || dive_deep(location)
  end
  
  private
  
  def dive_deep location
    matches = location.match /([^\[\]]*)\[(.*)\]/
    matches ? continue_dive(matches[1], matches[2]) : nil
  end
  
  def continue_dive key, remainder
    value = self[key] || self[key.to_sym]
    value.dive remainder
  end
end

class Hash
  include Dive
end