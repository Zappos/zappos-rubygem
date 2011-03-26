module Zappos
  class Client
    module Similarity

      def similarity(options={})
        get_response( '/Search/Similarity', options )
      end
      
    end
  end
end