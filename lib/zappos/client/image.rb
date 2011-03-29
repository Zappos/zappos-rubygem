module Zappos
  class Client
    module Image

      def image(options={})
        get_response( '/Image', :query_params => options )
      end
      
    end
  end
end