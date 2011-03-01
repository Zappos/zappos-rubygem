require File.expand_path(File.dirname(__FILE__) + '/base_client')

module Patron
  
  class Client < BaseClient
    
    def initialize(key, options={})
      @key = key
    end

    Dir[ File.expand_path('../client/*.rb', __FILE__) ].each{ |f| require f }
    include Patron::Client::Search
    include Patron::Client::Product
    include Patron::Client::Image
    include Patron::Client::Statistics
    include Patron::Client::Brand
    include Patron::Client::AutoComplete
    include Patron::Client::CoreValue
    include Patron::Client::Similarity

  end
end