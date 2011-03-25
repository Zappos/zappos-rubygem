require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Zappos::Client::Search do
  
  before do
    @zappos = Zappos::Client.new( API_KEY )
  end

  it "can search for a term" do
    results = @zappos.search( :term => 'boots' )
    results.should be_a_kind_of Zappos::Response
    results.success?.should == true
  end

  it "can have includes" do
    results = @zappos.search( :term => 'boots', :includes => %q{ description videoUrl } )
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
  
  it "can list facet fields" do
    results = @zappos.search_facet_list()
    results.should be_an_instance_of Array
    results.length.should > 0
  end
  
  it "can list facet field values" do
    results = @zappos.search_facet_values('colorFacet')
    results.should be_an_instance_of Array
    results.length.should > 0
    
    bad_data = @zappos.search_facet_values('someStupidFacetThatDoesntExist')
    bad_data.should == nil
  end
    
end