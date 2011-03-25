require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Zappos::Response do

  context "valid response" do

    before do
      http_response = stub_http_response_with('product_response.json')
      @response = Zappos::Response.new( http_response, 'product' )
    end

    it "has results" do
      @response.product.should be_an( Array )
    end

    it "has an iterator" do
      @response.product.each do |product|
        product.should be_a( Hash )
      end
    end
    
    it "has an object-like interface" do
      @response.product.first.productName.should == "Chuck Taylor Vintage Slip"
      @response.product.first.styles.first.color.should == "Athletic Navy"
    end
    

  end

  context "invalid response" do

    before do
      @zappos = Zappos::Client.new( API_KEY )
      @response = @zappos.search( :super_monkey => 'bazinga' )
    end

  end

end