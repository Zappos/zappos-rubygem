require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Zappos::Client::Product do
  
  before do
    @zappos = Zappos::Client.new( API_KEY )
  end
  
  context "stock lookup convenience functions" do
    
    before do
      stub_client_response_with( @zappos, 'product_stock_response.json' )
    end
    
    it "can return a nice list of dropdowns for a product" do
      dropdowns = @zappos.product_dropdowns( 7217113 )
      dropdowns.should be_an Array
      dropdowns.first[:name].should == 'color'
      dropdowns.last[:name].should match(/^d\d+$/)
      dropdowns.each do |dd|
        dd.should have_key :name
        dd.should have_key :label
        dd.should have_key :values            
        dd[:values].length.should > 0
        dd[:values].each do |value|
          value.should be_an Array
          value.length.should == 2
        end
      end
    end
      
    it "can look up a stock by color_id and dimension_ids array" do
      # Array dimensions
      stocks = @zappos.find_product_stocks( 7217113, 1777, [ 60902, 60558 ] )
      stocks.should be_an Array
      stocks.length.should == 1
      stocks.first.id.should == "16862385"
    end

    it "can look up a stock by color_id and dimension_ids hash" do
      # Hash dimensions
      stocks = @zappos.find_product_stocks( 7217113, 241863, { :d3 => 60903, :d4 => 60558 } )
      stocks.should be_an Array
      stocks.length.should == 1
      stocks.first.id.should == "10684487"
    end
      
    it "can return partial matches" do
      # Partial matches (because I just specified one of the dimensions)
      stocks = @zappos.find_product_stocks( 7217113, 11366, [ 60558 ])
      stocks.should be_an Array
      stocks.length.should == 13
    end

  end
  
  
end