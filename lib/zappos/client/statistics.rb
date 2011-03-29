module Zappos
  class Client
    module Statistics

      def statistics(options={})
        get_response( '/Statistics', :query_params => options )
      end

    end
  end
end