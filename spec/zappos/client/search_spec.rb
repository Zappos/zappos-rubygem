require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Zappos::Client::Search do
  
  before do
    @zappos = Zappos::Client.new( API_KEY )
  end
  
  context "search" do

    it "can search for a term" do
      results = @zappos.search( :term => 'boots' )
      results.should be_a_kind_of Zappos::Response
      results.success?.should == true
    end

    it "doesn't include everything by default" do
      response = @zappos.search( :term => 'boots' )
      response.results.first.should_not have_key('description')
    end

    it "can have includes" do
      results = @zappos.search( :term => 'boots', :includes => %w{ description videoUrl } )
      results.results.first.should have_key('description')
      results.results.first.should have_key('videoUrl')
    end
      
    it "can do a batch search" do
      # http://api.zappos.com/Search?batch=[
      #   filters={"txAttrFacet_ShortStyles":["Bermuda"]}%26sort={"recentSales":"desc"},
      #   filters={"subCategoryFacet":["Skirts"]}%26sort={"recentSales":"desc"},
      #   filters={"zc2":["Sunglasses"]}%26sort={"recentSales":"desc"},
      #   filters={"zc2":["Sandals"]}%26sort={"recentSales":"desc"},
      #   filters={"txAttrFacet_DressTypes":["Shirt+Dresses"]}%26sort={"recentSales":"desc"}
      # ]&key=78f7484fa8e3811432330cd542c208e1
      results = @zappos.search(
        :batch => [
          { :filters => { :txAttrFacet_ShortStyles => ['Bermuda'] }, :sort => { :recentSales => 'desc' }},
          { :filters => { :subCategoryFacet => ['Skirts'] }, :sort => { :recentSales => 'desc' } },
          { :filters => { :zc2 => ['Sunglasses'] }, :sort => { :recentSales => 'desc' } },
          { :filters => { :zc2 => ['Sandals'] }, :sort => { :recentSales => 'desc' } },
          { :filters => { :txAttrFacet_DressTypes => ['Shirt+Dresses'] }, :sort => { :recentSales => 'desc' } }
        ]
      )
      results.should be_a_kind_of Zappos::Response
      results.batchResults.should be_an Array
      results.batchResults.first.results.first.productName.should be_a String
      results.success?.should == true
    end
        
    it "can handle batch searches with ampersands" do
      results = @zappos.search( 
        :batch => [ 
          { "filters" => { "zc1" => [ "Home" ], "zc2" => [ "Office & School Supplies", "Home Decor" ] }  }
        ]
      )
      results.should be_a_kind_of Zappos::Response
      results.batchResults.should be_an Array
      results.batchResults.first.results.first.productName.should be_a String
      results.success?.should == true
    end

  end
  
  it "can list facet fields" do
    results = @zappos.search_facet_list()
    results.should be_an_instance_of Array
    results.length.should > 0
  end
  
  it "can list facet field values" do
    results = @zappos.search_facet_values('colorFacet')
    results.should be_an_instance_of Array
    results.length.should > 0
  end

  it "responds to a bad facet value request with nil" do
    response = @zappos.search_facet_values('someStupidFacetThatDoesntExist')
    response.should == nil
  end
  
  context "decode_search_url" do
  
    it "can decode terms with filters" do
      params = @zappos.decode_search_url('/search/green+tennis+shoes/filter/txAttrFacet_Gender/%22Women%22/zc1/%22Shoes%22/colorFacet/%22White%22')
      params.should == {
        :term    => 'green tennis shoes',
        :filters => {
          :txAttrFacet_Gender => [ "Women" ],
          :zc1                => [ "Shoes" ],
          :colorFacet         => [ "White" ]
        }
      }
    end
  
    it "can handle null searches and sorts" do
      params = @zappos.decode_search_url('/search/null/filter/brandNameFacet/%22Nike%22/txAttrFacet_Gender/%22Women%22/txAttrFacet_Performance/%22Crosstraining%22/sort/goliveRecentSalesStyle/desc')
      params.should == {
        :filters => {
          :brandNameFacet => [ "Nike" ],
          :txAttrFacet_Gender => [ "Women" ],
          :txAttrFacet_Performance => [ "Crosstraining" ]
        },
        :sort => {
          :goliveRecentSalesStyle => 'desc'
        }
      }
    end
  
    it "knows about pages" do
      params = @zappos.decode_search_url('/search/sexy heels/filter/colorFacet/"Red"/txAttrFacet_Gender/"Women"/page/2')
      params.should == {
        :term => "sexy heels",
        :filters => {
          :colorFacet => [ "Red" ],
          :txAttrFacet_Gender => [ "Women" ]
        },
        :page => "2"
      }
    end
  
    it "can handle brand search urls" do
      params = @zappos.decode_search_url('/search/brand/213/filter/txAttrFacet_Gender/%22Men%22/zc2/%22Boots%22')
      params.should == {
        :filters => {
          :brandId => [ "213" ],
          :txAttrFacet_Gender => [ "Men" ],
          :zc2 => [ "Boots" ]
        }
      }
    end
    
    it "can guess at zfc'd urls" do
      params = @zappos.decode_search_url('/green-tennis-shoes')
      params.should == {
        :term => "green tennis shoes"
      }
    end
    
  end
  
  context "encode_search_url" do
    
    it "can convert a search object into a URL" do
      @zappos.encode_search_url({ "filters" => { "txCategoryFacet_ZetaCategories2" => [ "Kitchen" ] } }).should == 
        '/search/null/filter/txCategoryFacet_ZetaCategories2/%22Kitchen%22'
    end
    
    it "can handle search terms" do
      @zappos.encode_search_url({ "term" => 'cat' }).should == '/search/cat'
    end
    
    it "can handle complicated queries with multiple facet values" do
      @zappos.encode_search_url({
        "filters" => {
          "isCouture" => ["false"],
          "zc1" => ["Bags"],
          "zc2" => ["Handbags"],
          "zc3" => ["Hobos","Satchel","Cross Body","Totes","Shoulder Bags"],
          "txAttrFacet_Theme" => ["Summer","Spring","Fall","Street"]
        }
      }).should == '/search/null/filter/isCouture/%22false%22/txAttrFacet_Theme/%22Summer+OR+Spring+OR+Fall+OR+Street%22/zc1/%22Bags%22/zc2/%22Handbags%22/zc3/%22Hobos+OR+Satchel+OR+Cross+Body+OR+Totes+OR+Shoulder+Bags%22'
    end
    
  end

  context "search_url_to_zso" do

    it "can take a relative search url and return a .zso link" do
      url = @zappos.search_url_to_zso('/search/null/filter/txCategoryFacet_ZetaCategories2/%22Kitchen%22')
      url.should match(/\.zso$/)
    end

    it "can take an absolute search url and return a .zso link" do
      url = @zappos.search_url_to_zso('http://www.zappos.com/search/null/filter/txCategoryFacet_ZetaCategories2/%22Kitchen%22')
      url.should match(/\.zso$/)
    end

  end
    
end