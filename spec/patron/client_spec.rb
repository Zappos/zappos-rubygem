require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Patron::Client do
  
  before do
    @patron = Patron::Client.new( API_KEY )
  end
  
  context "Search API" do
    
    it "can search for a term" do  
      results = @patron.search( :term => 'boots' )
      results.should be_an_instance_of Hash
      results['statusCode'].should == '200'
    end
    
    it "can get a product" do
      results = @patron.product
    end
    
  end
    
end
