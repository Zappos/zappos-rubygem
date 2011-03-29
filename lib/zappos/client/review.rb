module Zappos
  class Client
    module Review

      def review(options={})
        get_response( '/Review', :query_params => options )
      end
            
    end
  end
end