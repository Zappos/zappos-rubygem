module Zappos
  class Client
    module Product
      
      def product(options={})
        get_response( '/Product', :query_params => options )
      end
      
    end
  end
end