require File.dirname(__FILE__) + '/../../lib/dive'

describe Hash, 'when extended' do
  
  it 'performs a dive on []' do
    hash = {'first' => {'second' => {'third' => 'deep value'}}}
    hash['first[second[third]]'].should == 'deep value'
  end
  
  it 'performs a dive store on []=' do
    hash = {'first' => {}}
    hash['first[second]'] = 'deep value'
    hash['first']['second'].should == 'deep value'
  end
  
  it "allows keys that aren't strings or symbols" do
    {['array'] => 'value'}[['array']].should == 'value'
  end
  
  it 'allows a nil key' do
    hash = {:x => :y}
    hash[nil].should == hash.default    
  end
end