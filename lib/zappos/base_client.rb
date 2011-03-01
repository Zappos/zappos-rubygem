require File.expand_path(File.dirname(__FILE__) + '/response')
require 'net/http'
require 'json'
require 'uri'
require 'cgi'

module Zappos
  class BaseClient
    
    BASE_URL = 'http://api-a.zappos.com'
    
    protected

    # Make a get request and return a hash
    def get( endpoint, params={} )
      query = encode_params( { :key => @key }.merge( params ) )
      uri = URI.parse("#{BASE_URL}#{endpoint}?#{query}")
      Net::HTTP.get_response( uri )
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