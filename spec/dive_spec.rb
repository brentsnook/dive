require 'dive'

describe Dive do
  
  describe 'diving' do
    
    describe 'with a location that matches a normal key' do
      it 'returns the normal value' do
        hash = {'first[second]' => 'normal value', 'first' => {'second' => 'deep value'}}
        hash.dive('first[second]').should == 'normal value'
      end
    end
    
    describe 'with a location that matches a deep key' do
      it 'returns the deep value' do
        hash = {'first' => {'second' => {'third' => 'deep value'}}}
        hash.dive('first[second[third]]').should == 'deep value'
      end
    end
  end
  
  it 'retrieves values that have a symbol as key' do
    hash = {:first => {:second => 'deep value'}}
    hash.dive('first[second]').should == 'deep value'
  end
  
  it 'ignores space around location parts'
  it 'returns nil if a value at any part of the location can not dive'
  it 'retrieves string keys before symbols'
end