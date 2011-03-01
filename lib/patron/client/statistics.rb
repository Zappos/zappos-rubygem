module Patron
  class Client
    module Statistics

      def statistics(options={})
        get( '/Statistics', options )
      end

    end
  end
end