require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Zappos::Client do
  
  before do
    @zappos = Zappos::Client.new( API_KEY )
  end
  
  context "Search API" do

    it "can search for a term" do
      results = @zappos.search( :term => 'boots' )
      results.should be_a_kind_of Zappos::Response
      results.success?.should == true
    end

    it "can have includes" do
      results = @zappos.search( :term => 'boots', :includes => %q{ description videoUrl } )
    end

  end
    
end
