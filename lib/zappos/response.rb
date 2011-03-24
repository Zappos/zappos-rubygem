require 'json'

module Zappos
  class Response

    #:nodoc
    def initialize( response, envelope=nil )
      @response=response
      @data = JSON.parse( @response.body )
      @envelope=envelope
    end

    # True if we had a successful response
    def success?
      (200..299) === @response.code.to_i
    end

    # Returns the error message for failed requests
    def error
      @data['message'] unless success?
    end

    # Return the array of result items
    def results
      data = @envelope ? @data[ @envelope ] : @data
      data.is_a?( Array ) ? data : [ data ]
    end

    # Total number of results possible
    def total_results
      @data['totalResultCount']
    end

    # Number of items in the response
    def length
      results.length
    end

    # Iterate over each result
    def each
      results.each do |item|
        yield item
      end
    end

  end
end