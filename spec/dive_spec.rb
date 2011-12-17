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
    
    it 'retrieves values that have a symbol as key' do
      pending do
        hash = {:first => {:second => 'deep value'}}
        hash.dive('first[second]').should == 'deep value'
      end
    end

    it 'ignores space around location parts' do
      pending do
        hash = {'first' => {'second' => {'third' => 'deep value'}}}
        hash.dive('first  [  second [  third  ] ] ').should == 'deep value'
      end
    end

    describe "when a value at any part of the location doesn't exist and default is nil" do
      it 'retrieves the default value' do
        hash = Hash.new nil
        hash['first'] = {'second' => {'third' => 'deep value'}}
        hash.dive('first[second[idontexist]]').should be_nil
      end
    end
    
    describe "when a string key and it's symbol equivalent both exist" do
      it 'retrieves the string value' do
        hash = {'first' => {'second' => 'string value', :second => 'symbol value'}}
        hash.dive('first[second]').should == 'string value'
      end
    end

    describe 'when a value at any part of the location can not dive' do
      it 'retrieves the default value' do
        hash = Hash.new nil
        hash['first'] = {'second' => "cantdive"}
        hash.dive('first[second[cantdive[fourth]]]').should be_nil
      end
    end
    
    describe 'when no normal key or dive location exists and default is nil' do
      it 'retrieves the default value' do
        hash = Hash.new nil
        hash['first'] = 'value'
        hash.dive('idontexist').should be_nil
      end
    end
    
    it 'still dives when the default value is not nil' do
      hash = Hash.new 'default'
      hash['first'] = {'second' => 'deep value'}
      hash.dive('first[second]').should == 'deep value'
    end
  end
  
end