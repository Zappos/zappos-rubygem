module Zappos
  class Client
    module Product
      
      def product(options={})
        get_response( '/Product', options )
      end
      
    end
  end
end