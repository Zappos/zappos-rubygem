require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Zappos::Response do

  context "valid stubbed response" do

    before do
      http_response = stub_http_response_with('product_response.json')
      @response = Zappos::Response.new( nil, nil, http_response )
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
    
    it "has an array-like interface" do
      @response['product'].first['styles'].first['color'].should == "Athletic Navy"
    end
    
    it "is indifferent to hash keys" do
      @response[:product].first[:styles].first[:color].should == "Athletic Navy"
    end
    
  end
  
  context "valid real response" do
    
    before do
      @zappos = Zappos::Client.new( API_KEY )
      @response = @zappos.search( :term => 'cat' )
    end
    
    it "knows its originating request url" do
      @response.request_uri.to_s.should == "http://api.zappos.com/Search?key=#{API_KEY}&term=cat"
    end
    
    it "knows its limit" do
      @response.limit.should == 10
      response2 = @zappos.search( :term => 'cat', :limit => 25 )
      response2.results.length.should == 25
      response2.limit.should == 25
    end
    
    it "knows what page it's on" do
      @response.page.should == 1
      response2 = @zappos.search( :term => 'cat', :page => 2 )
      response2.page.should == 2
    end
    
    it "can fetch result count" do
      @response.total_results.should > 0
    end

    it "knows how many pages there are" do
      results = @response.total_results
      limit   = @response.limit
      @response.total_pages.should == ( results.to_f / limit ).ceil
    end
    
    it "can fetch the next page" do
      response = @zappos.search( :term => 'cat' )
      page2 = response.next_page
      page2.should be_a_kind_of Zappos::Response
      page2.page.should == 2
      page2.class.should == response.class
    end
    
  end

  context "invalid response" do

    before do
      @zappos = Zappos::Client.new( API_KEY )
      @response = @zappos.search( :super_monkey => 'bazinga' )
    end

    it "is a complete failure" do
      @response.success? == false
    end

  end

end