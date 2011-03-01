module Patron
  class Client
    module Review

      def review(options={})
        get( '/Review', options )
      end
            
    end
  end
end