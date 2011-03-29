module Zappos
  class Client
    module Brand

      def brand(options={})
        get_response( '/Brand', :query_params => options )
      end

    end
  end
end