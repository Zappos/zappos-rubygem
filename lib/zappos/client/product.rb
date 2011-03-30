module Zappos
  class Client
    module Product
      
      def product(options={})
        get_response( '/Product', :query_params => options )
      end
      
      # Return an array of dropdowns for the given product_id
      def product_dropdowns( product_id )
        dropdowns = []
        product = _get_product_stocks( product_id )
        # Color Dropdown
        dropdowns.push({
          :label  => 'Color',
          :name   => 'color',
          :values => product.styles.collect { |style| [ style.color, style.colorId ] }
        })
        # Size Dropdowns
        product.sizing.dimensions.each do |dimension|
          dropdowns.push({
            :label  => dimension.name.capitalize,
            :name   => "d#{dimension.id}",
            :values => dimension.units.inject([]) { |sizes,unit| sizes += unit[:values].collect { |v| [ v.value, v.id ] } }
          })
        end
        dropdowns
      end
      
      # Given a product_id, color_id and dimension_id Hash or Array, return the stock object
      def find_product_stocks( product_id, color_id=nil, dimension_value_ids=[] )
        product = _get_product_stocks( product_id )
        # The keys don't matter, so let's convert to an array
        dimension_value_ids = dimension_value_ids.values if dimension_value_ids.is_a?( Hash )
        
        stocks = product.sizing.stockData.clone()
        # Filter on color
        if color_id
          color = color_id.to_s
          stocks.delete_if { |s| s.color != color }
        end
        
        # Filter on any dimensions given
        dimension_value_ids.each do |value_id|
          # This is kind of primitive..
          stocks.delete_if do |stock|
            delete=true
            stock.each_pair do |key,value|
              next unless key.match(/^d\d+$/)
              delete=false if value == value_id.to_s
            end
            delete
          end
        end
        stocks
      end
      
      private
      
      # Get all relevant stock information for a product
      def _get_product_stocks( product_id )
        product = self.product(
          :id => product_id,
          :includes => %w{ styles stocks colorId sizing dimensions }
        ).product.first
      end
      
    end
  end
end