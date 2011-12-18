require File.dirname(__FILE__) + '/spec_helper'

describe Dive do
  
  describe 'reading' do
    
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
      hash = {:first => {:second => 'deep value'}}
      hash.dive('first[second]').should == 'deep value'
    end

    it 'ignores space around location parts' do
      hash = {'first' => {'second' => {'third' => 'deep value'}}}
      hash.dive('first  [  second [  third  ] ] ').should == 'deep value'
    end

    describe "when a value at any part of the location doesn't exist" do
      it 'retrieves the default value of the hash where no key was found' do
        hash = {'first' => {'second' => Hash.new('default')}}
        hash.dive('first[second[idontexist]]').should == 'default'
      end
    end
    
    describe "when a string key and it's symbol equivalent both exist" do
      it 'retrieves the string value' do
        hash = {'first' => {'second' => 'string value', :second => 'symbol value'}}
        hash.dive('first[second]').should == 'string value'
      end
    end

    describe 'when a hash at any part of the location can not dive' do
      
      before do
        @hash = {'first' => {'second' => 'cantdive'}}
      end
      
      describe 'when that hash was created with a default value' do
        it 'retrieves the default value' do
          @hash['first'].default = 'default'
          @hash.dive('first[second[cantdive[fourth]]]').should == 'default'
        end
      end
      
      describe 'when that hash was created with a default proc' do
        
        before do
          @hash['first'].default_proc = proc { |hash, key| "default proc: #{key}"}
          @result = @hash.dive('first[second[cantdive[fourth]]]')
        end
      
        it 'retrieves the result of evaluating the default proc' do
          @result.should include('default proc')
        end
      
        it 'uses the remainder of the location as the proc key' do
          @result.should include('cantdive[fourth]')
        end
      end
    end
    
    describe 'when no normal key or dive location exists and default is nil' do
      it 'retrieves the default value' do
        hash = Hash.new nil
        hash['first'] = 'value'
        hash.dive('idontexist').should be_nil
      end
    end
    
    it 'still attempts to dive when the default value is not nil' do
      hash = Hash.new 'default'
      hash['first'] = {'second' => 'deep value'}
      hash.dive('first[second]').should == 'deep value'
    end
  end
  
end