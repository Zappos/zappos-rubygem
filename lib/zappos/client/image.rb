module Zappos
  class Client
    module Image

      def image(options={})
        get_response( '/Image', options )
      end
      
    end
  end
end