require 'uri'

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
      
      # The opposite of decode_search_url - takes a search query and turns it into a Zappos search URL
      def encode_search_url( query_object )
        return '/' unless query_object && query_object.is_a?( Hash )
        
        query = Hashie::Mash.new( query_object )
        url_builder = [ 'search' ]

        # Handle search term
        url_builder << ( query[:term] ? CGI::escape( query[:term] ) : 'null' )
        
        if query[:filters] && query[:filters].is_a?( Hash )
          url_builder << 'filter'
          query[:filters].keys.sort.each do |key|
            url_builder << CGI::escape( key )
            url_builder << CGI::escape( '"'+ query[:filters][ key ].join(' OR ') + '"' )
          end
        end
        
        return '/' + url_builder.join('/')
      end

      def search_url_to_zso( url )
        uri = URI.parse( url )
        request = Zappos::Request.new( 'Head', 'www.zappos.com', uri.path )
        response = request.execute
        if response.is_a?( Net::HTTPRedirection )
          location = URI.parse( response['Location'] )
          if uri.absolute? && location.relative?
            uri.path = location.path
            return uri.to_s
          else
            return location.to_s
          end
        else
          return url
        end
      rescue Exception
        return url
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