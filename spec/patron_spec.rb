require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Patron do
  
  it "Returns a client" do
    patron = Patron.client( API_KEY ).should be_an_instance_of( Patron::Client )
  end
  
end
