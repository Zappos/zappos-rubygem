module Patron
  class Client
    module AutoComplete
      
      def auto_complete(options={})
        get( '/AutoComplete', options )
      end
      
    end
  end
end