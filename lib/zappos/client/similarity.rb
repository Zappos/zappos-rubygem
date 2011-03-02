module Zappos
  class Client
    module Similarity

      def similarity(options={})
        response = get( '/Search/Similarity', options )
        Zappos::Response.new( response, 'results' )
      end
      
    end
  end
end