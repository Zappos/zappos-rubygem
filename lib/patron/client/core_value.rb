module Patron
  class Client
    module CoreValue

      def core_value(options={})
        get( '/CoreValue', options )
      end
      
    end
  end
end