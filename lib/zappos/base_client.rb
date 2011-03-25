require File.expand_path(File.dirname(__FILE__) + '/response')
require 'net/http'
require 'net/https'
require 'json'
require 'uri'
require 'cgi'

module Zappos
  class BaseClient
        
    protected

    # Make a get request and return a hash
    def get( endpoint, params={}, ssl = false )
      query = if params[:batch]
        batch_sets = []
        params[:batch].each do |set|
          batch_sets << encode_params( set )
        end
        encode_params( { :key => @key }.merge({ :batch => batch_sets }) )
      else
        encode_params( { :key => @key }.merge( params ) )
      end

      uri = URI.parse("#{ssl ? "https" : "http"}://#{@base_url}#{endpoint}?#{query}")
      
      if ssl
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        http.request(request)
      else
        Net::HTTP.get_response( uri )
      end
    end
    
    def post(endpoint, get_params = {}, post_params = {}, ssl = false)
      get_params = encode_params( { :key => @key }.merge( get_params ) )
      uri = URI.parse("#{ssl ? "https" : "http"}://#{@base_url}#{endpoint}?#{get_params}")
      puts uri
      
      if ssl
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data(post_params)
        http.request(request)
      else
        Net::HTTP.post_form(uri, post_params)
      end
    end
    
    def put(endpoint, get_params = {}, put_params = {}, ssl = false)
      get_params = encode_params( { :key => @key }.merge( get_params ) )
      uri = URI.parse("#{ssl ? "https" : "http"}://#{@base_url}#{endpoint}?#{get_params}")
      puts uri
      
      if ssl
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Put.new(uri.request_uri)
        request.set_form_data(put_params)
        http.request(request)
      else
        Net::HTTP.post_form(uri, put_params)
      end
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