module Zappos
  class Client
    module Similarity

      def similarity(options={})
        get_response( '/Search/Similarity', :query_params => options )
      end
      
    end
  end
end