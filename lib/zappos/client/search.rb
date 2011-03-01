module Zappos
  class Client
    module Search
      
      def search(options={})
        get( '/Search', options )
      end
      
    end
  end
end