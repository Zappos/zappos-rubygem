module Zappos
  class Client
    module Brand

      def brand(options={})
        get( '/Brand', options )
      end

    end
  end
end