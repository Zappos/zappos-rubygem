module Patron
  class Client
    module Similarity

      def similarity(options={})
        get( '/Search/Similarity', options )
      end
      
    end
  end
end