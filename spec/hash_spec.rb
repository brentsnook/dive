require File.dirname(__FILE__) + '/spec_helper'

describe Hash, 'when extended' do
  
  it 'performs a dive on []' do
    hash = {'first' => {'second' => {'third' => 'deep value'}}}
    hash['first[second[third]]'].should == 'deep value'
  end
  
  it "allows keys that aren't strings or symbols" do
    {['array'] => 'value'}[['array']].should == 'value'
  end
end