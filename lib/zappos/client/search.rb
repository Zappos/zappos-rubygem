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
      
      # Decodes a Zappos.com search URL into a hash for a Search API call
      def decode_search_url( url )
        query = {}
        case
        when parts = url.match(%r{^/search/([^/?]*)(?:/filter/?(.*?))?(?:/orig/(.*?))?(?:/termLander/(.*?))?(?:/page/(\d+))?(?:/sort/(.*?))?(?:/debug/(.*?))?(?:/noEncode/(true|false?))?/?(?:\?(.*))?$})
          term = CGI::unescape( parts[1] )
          query[:term] = term unless term == 'null'
          query[:filters] = parse_filters( parts[2] )
          query[:sort] = parse_sort( parts[6] )
          query[:page] = parts[5]
        when parts = url.match(%r{^/search/brand/(\d+)(?:/filter/?(.*?))?(?:/page/(\d+))?(?:/sort/(.*?))?(?:/debug/(.*?))?(?:/noEncode/(true|false?))?/?(?:\?(.*))?$})
          query[:filters] = parse_filters( parts[2] ) || {}
          query[:filters][:brandId] = [ parts[1] ]
          query[:sort] = parse_sort( parts[6] )
          query[:page] = parts[5]
        when parts = url.match(%r{^/([^/?]+)$})
          query[:term] = CGI::unescape(parts[1]).gsub(/[_-]/, ' ')
        end
        query.delete_if {|key,value| !value }
      end
      
      private
      
      def parse_filters(filter_string)
        return unless filter_string
        filters = {}
        filter_string.split('/').each_slice(2) do |key,value|
          facet = key.to_sym
          filters[ facet ] ||= [] << CGI::unescape( value ).gsub(/^"|"$/,'')
        end
        return filters
      end
      
      def parse_sort( sort_string )
        return unless sort_string
        key, value = sort_string.split('/')
        { key.to_sym => CGI::unescape( value ) }
      end
      
      def parse_page( page_string )
        return unless page_string
        page, number = page_string.split('/')
        return number.to_i
      end
      
    end
  end
end