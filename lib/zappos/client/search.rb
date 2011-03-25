module Zappos
  class Client
    module Search
      
      def search(options={})
        response = get( '/Search', options )
        if options[:batch]
          Zappos::Response.new( response )
        else
          Zappos::Response.new( response )
        end
      end
      
      def search_facet_list()
        response = get( '/Search', { :list => 'facetFields' } )
        Zappos::Response.new( response, 'facetFields' ).facetFields rescue nil
      end
      
      def search_facet_values( facet )
        response = get( '/Search', { :facets => [ facet], :excludes => [ 'results' ] } )
        Zappos::Response.new( response ).facets[0].values rescue nil
      end
      
    end
  end
end