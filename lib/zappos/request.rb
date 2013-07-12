require 'net/http'
require 'net/https'
require 'hashie'
require 'json'
require 'uri'
require 'cgi'

module Zappos
  class Request #:nodoc:all

    attr_accessor :use_ssl, :response_class
    attr_reader :query_params, :body_params, :cookies
    
    def initialize( method, host, port, path, options={} )
      @method = method
      @host   = host
      @port   = port
      @path   = path
    end
    
    # Generate and return a new URI object
    def uri()
      uri = ( use_ssl ? URI::HTTPS : URI::HTTP ).build(
        :host   => @host,
        :port   => @port,
        :path   => @path
      )
      if @query_params
        uri.query = self.class.encode_params( @query_params )
      end
      uri
    end
    
    # Store query params as a Mash to avoid symbol / string key collissions
    def query_params=(params)
      @query_params = Hashie::Mash.new( params )
    end

    # Store body params as a Mash to avoid symbol / string key collissions
    def body_params=(params)
      @body_params = Hashie::Mash.new( params )
    end
    
    # Store cookies.. ditto
    def cookies=(cookies)
      @cookies = Hashie::Mash.new( cookies )
    end
    
    # A combination of body and query parameters.
    def params()
      params = query_params.clone()
      if body_params
        params.merge( body_params )
      end
      params
    end
    
    # Override a parameter in either the body or query paramters
    def replace_param( name, value )
      if body_params and body_params[name]
        body_params[name] = value
      else
        query_params[name] = value
      end
    end
    
    # Generate and return a new Net::HTTP request
    def request()
      request = Net::HTTP.const_get( @method.to_s.capitalize ).new( uri.request_uri )
      request.add_field("User-Agent", "zappos_rb v#{Zappos::Client.version}")
      if @body_params
        request.set_form_data( @body_params )
      end
      if cookies
        cookie_pairs = []
        cookies.each do |key,value|
          next unless value
          # Zappos uses this odd multi-value cookie format
          escaped_value = value.split('&').collect { |v| CGI::escape(v) }.join('&')
          cookie_pairs << "#{key}=#{escaped_value}"
        end
        request.add_field( "Cookie", cookie_pairs.join(';') ) if cookie_pairs.length > 0
      end
      request
    end
    
    # Execute our request and return a raw Net::HTTP::Response
    def execute()
      uri = self.uri()
      http = Net::HTTP.new( uri.host, uri.port )
      if use_ssl
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response = http.request( request )
      response
    end
    
    # Convert a hash of params into a query string
    def self.encode_params( params )
      pairs = []
      params.each_pair do |key,value|
        if value.is_a?( Hash ) || value.is_a?( Array )
          if key.to_s == 'batch'
            # Weird fix for batch queries - DEV-24236
            pairs << "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_json).gsub('%2526','%255Cu0026')}"
          else
            pairs << "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_json)}"
          end
        else
          pairs << "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}"
        end
      end
      # We return the parameter pairs sorted to keep predictable URLs - good for cache and unit tests. ^_^
      return pairs.sort.join('&')
    end
    
  end
end