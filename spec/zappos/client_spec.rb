require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Zappos::Client do
  
  before do
    @zappos = Zappos::Client.new( API_KEY )
  end
  
  context "Search API" do
    
    it "can search for a term" do  
      results = @zappos.search( :term => 'boots' )
      results.should be_an_instance_of Hash
      results['statusCode'].should == '200'
    end
    
    it "can get a product" do
      results = @zappos.product
    end
    
  end
    
end
