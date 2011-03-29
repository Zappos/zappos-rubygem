module Zappos
  class Client
    module AutoComplete
      
      def auto_complete(options={})
        get_response( '/AutoComplete', :query_params => options )
      end
      
    end
  end
end