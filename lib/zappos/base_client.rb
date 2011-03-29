require File.expand_path(File.dirname(__FILE__) + '/request')
require File.expand_path(File.dirname(__FILE__) + '/response')
require File.expand_path(File.dirname(__FILE__) + '/paginated_response')

module Zappos
  class BaseClient #:nodoc:all
    
    # Execute a Zappos::Request object and return a wrapped Zappos::Response
    def execute( request )
      if response = request.execute()
        response_class = request.response_class ? Zappos.const_get( request.response_class ) : Zappos::Response;
        response_class.new( self, request, response )
      end      
    end
    
    protected
    
    # Override to provide credentials that get injected into the query string
    def credentials
      {}
    end

    # Create a request
    def request( method, endpoint, options={} )
      request = Zappos::Request.new( method, @base_url, endpoint )
      if options[:ssl]
        request.use_ssl = true
      end
      query_params = options[:query_params] || {}
      # Per Jimmy, it's best to pass the key in they query params      
      request.query_params = credentials.merge( query_params )
      if options[:body_params]
        request.body_params = options[:body_params]
      end
      if options[:response_class]
        request.response_class = options[:response_class]
      end
      request
    end
        
    # --------------------
    # HTTP request methods
    # --------------------
    
    def get( endpoint, options={} )
      convert_batch_params( options[:query_params] )
      request( 'Get', endpoint, options )
    end
        
    def post( endpoint, options={} )
      request( 'Post', endpoint, options )
    end

    def put( endpoint, options={} )
      request( 'Put', endpoint, options )
    end

    def delete( endpoint, options={} )
      request( 'Delete', endpoint, options )
    end
    
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Bacon-wrapped convenience methods
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    def get_response( endpoint, options={} )
      execute( get( endpoint, options ) )
    end

    def post_response( endpoint, options={} )
      execute( post( endpoint, options ) )
    end

    def put_response( endpoint, options={} )
      execute( put( endpoint, options ) )
    end

    def delete_response( endpoint, options={} )
      execute( delete( endpoint, options ) )
    end
            
    private
    
    # Batch queries must have their parameters encoded specially
    def convert_batch_params( params )
      return unless params
      if params[:batch]
        batch_sets = []
        params[:batch].each do |set|
          batch_sets << Zappos::Request.encode_params( set )
        end
        params[:batch] = batch_sets
      end
    end
    
  end
end