module Zappos
  class Client
    module Brand

      def brand(options={})
        get_response( '/Brand', options )
      end

    end
  end
end