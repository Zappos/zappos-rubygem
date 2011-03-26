require File.expand_path(File.dirname(__FILE__) + '/response')
require 'net/http'
require 'net/https'
require 'json'
require 'uri'
require 'cgi'

module Zappos
  class BaseClient
        
    protected
    
    # Master request method
    def request( method, endpoint, query_params, body_params, ssl )
      
      uri = URI::HTTP.build(
        :scheme => ssl ? 'https' : 'http',
        :host   => @base_url,
        :path   => endpoint
      )
      if query_params
        uri.query = encode_params( { :key => @key }.merge( query_params ) )
      end

      request = Net::HTTP.const_get( method.to_s.capitalize ).new( uri.request_uri )
      if body_params
        request.set_form_data( body_params )
      end

      http = Net::HTTP.new( uri.host, uri.port )
      if ssl
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      
      # TODO: Send some headers?
      # User-Agent
      # {:accept => '*/*; q=0.5, application/xml', :accept_encoding => 'gzip, deflate'}
      
      http.request( request )
    end
    
    # HTTP methods
    
    def get( endpoint, query_params={}, body_params={}, ssl=false )
      convert_batch_params( query_params )
      request( 'Get', endpoint, query_params, body_params, ssl )
    end
        
    def post( endpoint, query_params={}, body_params={}, ssl=false )
      request( 'Post', endpoint, query_params, post_params, ssl )
    end

    def put( endpoint, query_params={}, body_params={}, ssl=false )
      request( 'Put', endpoint, query_params, post_params, ssl )
    end

    def delete( endpoint, query_params={}, body_params={}, ssl=false )
      request( 'Delete', endpoint, query_params, post_params, ssl )
    end
    
    # Bacon-wrapped convenience methods
    
    def get_response( *args )
      Zappos::Response.new( get( *args ) )
    end

    def post_response( *args )
      Zappos::Response.new( post( *args ) )
    end

    def put_response( *args )
      Zappos::Response.new( put( *args ) )      
    end

    def delete_response( *args )
      Zappos::Response.new( delete( *args ) )      
    end
            
    private
    
    # Batch queries must have their parameters encoded specially
    def convert_batch_params( params )
      if params[:batch]
        batch_sets = []
        params[:batch].each do |set|
          batch_sets << encode_params( set )
        end
        params[:batch] = batch_sets
      end
    end
    
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