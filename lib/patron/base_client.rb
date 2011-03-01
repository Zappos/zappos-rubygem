require 'net/http'
require 'json'
require 'uri'
require 'cgi'

module Patron
  class BaseClient
    
    BASE_URL = 'http://api.zappos.com'
    
    protected

    # Make a get request and return a hash
    def get( endpoint, params={} )
      query = encode_params( { :key => @key }.merge( params ) )
      url = "#{BASE_URL}#{endpoint}?#{query}"
      response = Net::HTTP.get_response( URI.parse(url) ).body.to_s
      return JSON.parse( response )
    end

    private
    
    # Convert a hash of params into a query string
    def encode_params( params )
      pairs = []
      params.each_pair do |key,value|
        if value.is_a?( Hash ) || value.is_a?( Array )
          pairs << "#{CGI::escape(key.to_s)}=#{CGI::escape(JSON.generate(value))}"
        else
          pairs << "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}"
        end
      end
      return pairs.join('&')
    end
    
  end
end