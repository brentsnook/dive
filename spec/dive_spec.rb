require File.dirname(__FILE__) + '/spec_helper'

describe Dive do
  
  describe 'diving' do
    
    describe 'with a location that matches a normal key' do
      it 'retrieves the normal value' do
        hash = {'first[second]' => 'normal value', 'first' => {'second' => 'deep value'}}
        hash.dive('first[second]').should == 'normal value'
      end
    end
    
    describe 'with a location that matches a deep key' do
      it 'retrieves the deep value' do
        hash = {'first' => {'second' => {'third' => 'deep value'}}}
        hash.dive('first[second[third]]').should == 'deep value'
      end
    end
  end
  
  it 'retrieves values that have a symbol as key' do
    hash = {:first => {:second => 'deep value'}}
    hash.dive('first[second]').should == 'deep value'
  end
  
  it 'ignores space around location parts' do
    hash = {'first' => {'second' => {'third' => 'deep value'}}}
    hash.dive('first  [  second [  third  ] ] ').should == 'deep value'
  end
  
  it 'retrieves nothing if a value at any part of the location can not dive' do
    hash = {'first' => {'second' => {'third' => 'deep value'}}}
    hash.dive('first[second[idontexist]]').should be_nil
  end
  
  it 'retrieves string keys before symbols' do
    hash = {'first' => {'second' => 'string value', :second => 'symbol value'}}
    hash.dive('first[second]').should == 'string value'
  end
  
  it 'retrieves nothing if a value at any point can not dive' do
    hash = {'first' => {'second' => "I can't dive :("}}
    hash.dive('first[second[third]]').should be_nil
  end
end