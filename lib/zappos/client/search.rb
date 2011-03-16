module Zappos
  class Client
    module Search
      
      def search(options={})
        response = get( '/Search', options )
        if options[:batch]
          Zappos::Response.new( response, 'batchResults' )
        else
          Zappos::Response.new( response, 'results' )
        end
      end
      
    end
  end
end