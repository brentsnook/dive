require File.dirname(__FILE__) + '/spec_helper'

describe Dive, 'when writing' do

  describe 'with a deep location' do
    it 'sets a deep value' do
      nested_hash = {'third' => 'deep value'}
      hash = {'first' => {'second' => nested_hash}}
      
      hash.dive_store('first[second[third]]', 'deep value')
      
      nested_hash['third'].should == 'deep value'
    end
  end
  
  describe 'with a normal location' do
    it 'sets a normal value' do
      hash = {}
      hash.dive_store 'normal', 'normal value'
      hash['normal'].should == 'normal value'
    end
  end
  
  describe "when parts of the location don't exist" do
    it 'creates each part as a new Hash' do
      hash = {}
      hash.dive_store 'first[second[third]]', 'value'
      hash['first']['second']['third'].should == 'value'
    end
  end
  
  describe 'when the value at the end of a location is not divable' do
    it 'raises a NoMethodError' do
      hash = {'first' => 'not divable'}
      lambda { hash.dive_store 'first[second]', 'value' }.should raise_exception(NoMethodError)
    end
  end
  
  it 'recognises symbol keys' do
    hash = {:first => {}}
    hash.dive_store ':first[:second]', 'value'
    hash[:first][:second].should == 'value'
  end
end