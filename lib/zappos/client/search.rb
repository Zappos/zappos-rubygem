module Zappos
  class Client
    module Search
      
      def search(options={})
        response = get( '/Search', options )
        Zappos::Response.new( response, 'results' )
      end
      
    end
  end
end