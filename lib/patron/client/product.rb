module Patron
  class Client
    module Product
      
      def product(options={})
        get( '/Product', options )
      end
      
    end
  end
end