require File.expand_path(File.dirname(__FILE__) + '/base_client')

module Zappos
  
  class Client < BaseClient
    
    def initialize(key, options={})
      @key = key
    end

    Dir[ File.expand_path('../client/*.rb', __FILE__) ].each{ |f| require f }
    include Zappos::Client::Search
    include Zappos::Client::Product
    include Zappos::Client::Image
    include Zappos::Client::Statistics
    include Zappos::Client::Brand
    include Zappos::Client::Review    
    include Zappos::Client::AutoComplete
    include Zappos::Client::CoreValue
    include Zappos::Client::Similarity

  end
end