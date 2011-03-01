require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Zappos::Response do

  context "valid response" do

    before do
      @zappos = Zappos::Client.new( API_KEY )
      @response = @zappos.search( :term => 'cat' )
    end

    it "has results" do
      @response.results.should be_an( Array )
    end

    it "has an iterator" do
      @response.each do |product|
        product.should be_a( Hash )
      end
    end

    it "has a length" do
      @response.length.should be_an( Integer )
      @response.length.should == @response.results.length
    end

  end

  context "invalid response" do

    before do
      @zappos = Zappos::Client.new( API_KEY )
      @response = @zappos.search( :super_monkey => 'bazinga' )
    end

  end

end