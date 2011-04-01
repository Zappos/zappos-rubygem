module Zappos
  class Client
    module Search
      
      def search(options={})
        get_response( '/Search', :query_params => options, :response_class => 'PaginatedResponse' )
      end
      
      def search_facet_list()
        response = get_response( '/Search', :query_params => { :list => 'facetFields' } )
        response.facetFields rescue nil
      end
      
      def search_facet_values( facet )
        response = get_response( '/Search', :query_params => { :facets => [ facet ], :excludes => [ 'results' ] } )
        response.facets.first[:values] rescue nil
      end
      
    end
  end
end