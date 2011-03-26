require 'json'
require 'hashie'

module Zappos
  class Response
    
    attr_accessor :data

    #:nodoc
    def initialize( response )
      @response = response
      data = JSON.parse( @response.body )
      @data = Hashie::Mash.new( data )
    end

    # True if we had a successful response
    def success?
      (200..299).include?( @response.code.to_i )
    end

    # Returns the error message for failed requests
    def error
      @data['message'] unless success?
    end

    # Total number of results possible
    def total_results
      @data['totalResultCount']
    end
    
    #:nodoc
    def method_missing( sym, *args, &block )
      key = sym.to_s
      return @data[ key ] if @data.key?( key )
      super(sym, *args, &block)
    end

  end
end