require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Zappos do
  
  it "Returns a client" do
    zappos = Zappos.client( API_KEY ).should be_an_instance_of( Zappos::Client )
  end
  
end
