module Zappos
  class Client
    module Search
      
      def search(options={})
        get_response( '/Search', options )
      end
      
      def search_facet_list()
        response = get_response( '/Search', { :list => 'facetFields' } )
        response.facetFields rescue nil
      end
      
      def search_facet_values( facet )
        response = get_response( '/Search', { :facets => [ facet], :excludes => [ 'results' ] } )
        response.facets.first.values rescue nil
      end
      
    end
  end
end