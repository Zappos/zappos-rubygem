module Zappos
  class Client
    module CoreValue

      def core_value(options={})
        get( '/CoreValue', options )
      end
      
    end
  end
end