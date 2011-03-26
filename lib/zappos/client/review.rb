module Zappos
  class Client
    module Review

      def review(options={})
        get_response( '/Review', options )
      end
            
    end
  end
end