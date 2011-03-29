require 'json'
require 'hashie'

module Zappos
  class Response
    
    attr_accessor :data
    
    def initialize( client, request, response ) #:nodoc
      @client   = client
      @request  = request
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
    
    # Return the URI for the request that generated this response
    def request_uri
      @request.uri
    end
    
    # Support array notation
    def []( key )
      @data[ key ]
    end
    
    # Magical catch-all delegating to the data for methods like response.totalResults
    def method_missing( sym, *args, &block ) #:nodoc:
      key = sym.to_s
      return @data[ key ] if @data.key?( key )
      super(sym, *args, &block)
    end

  end
end