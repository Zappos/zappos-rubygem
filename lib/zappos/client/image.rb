module Zappos
  class Client
    module Image

      def image(options={})
        response = get( '/Image', options )
        Zappos::Response.new( response )
      end
      
    end
  end
end