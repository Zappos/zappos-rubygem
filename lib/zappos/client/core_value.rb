module Zappos
  class Client
    module CoreValue

      def core_value(options={})
        get_response( '/CoreValue', :query_params => options )
      end
      
    end
  end
end