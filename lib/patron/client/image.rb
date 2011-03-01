module Patron
  class Client
    module Image

      def image(options={})
        get( '/Image', options )
      end
      
    end
  end
end