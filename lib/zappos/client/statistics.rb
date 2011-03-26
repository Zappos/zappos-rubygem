module Zappos
  class Client
    module Statistics

      def statistics(options={})
        get_response( '/Statistics', options )
      end

    end
  end
end