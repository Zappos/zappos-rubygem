require 'json'
require 'hashie'

module Zappos
  class Response
    
    attr_accessor :data
    
    def initialize( client, request, response ) #:nodoc
      @client      = client
      @request     = request
      @response    = response
      data = begin
        JSON.parse( @response.body )
      rescue JSON::ParserError
        @parse_error = true
        { :error => "JSON Parser Error:\n#{@response.body}" }
      end
      unless data.is_a?( Hash )
        data = { response: data }
      end
      @data = Hashie::Mash.new( data )
    end

    # True if we had a successful response
    def success?
      (200..299).include?( code )
    end
    
    # Returns true if there was a parse error
    def parse_error?
      @parse_error ? true : false
    end

    # Returns the error message for failed requests
    def error
      return if success? unless parse_error?
      @data['error'] || @data['message']
    end
    
    # Return the URI for the request that generated this response
    def request_uri
      @request.uri
    end
    
    # Return the raw unparsed response body
    def body
      @response.body
    end
    
    # Return the HTTP response code
    def code
      @response.code.to_i
    end
    
    # Return the raw Net:HTTPResponse object
    def response
      @response
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