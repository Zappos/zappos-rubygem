module Zappos
  class Client
    module Product
      
      def product(options={})
        response = get( '/Product', options )
        Zappos::Response.new( response, 'product' )
      end
      
    end
  end
end