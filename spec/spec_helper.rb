$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'zappos'
require 'net/http'

API_KEY = '190a7d0566b7abba2e041db5e751b1251e593aa2'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f }

def file_fixture(filename)
  open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename.to_s}")).read
end

def stub_http_response_with(filename,code=200)
  format = filename.split('.').last.intern
  data = file_fixture(filename)
  response = Net::HTTPResponse.new( '1.1', code, '' )
  response.stub!(:body).and_return(data)
  response
end

def stub_client_response_with( zappos, filename )
  response = stub_http_response_with( filename )
  zappos.stub!( :execute ).and_return(
    Zappos::Response.new( zappos, nil, response )
  )
end

RSpec.configure do |config|
  
end
