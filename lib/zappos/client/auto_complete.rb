module Zappos
  class Client
    module AutoComplete
      
      def auto_complete(options={})
        get_response( '/AutoComplete', options )
      end
      
    end
  end
end