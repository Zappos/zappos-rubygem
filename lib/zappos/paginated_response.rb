require File.expand_path( File.dirname(__FILE__) + '/response' )

module Zappos
  class PaginatedResponse < Response
    
    # Total number of results possible
    def total_results
      @data.totalResultCount.to_i
    end
    
    # Number of pages if we have a request that supports pages
    def total_pages
      ( total_results.to_f / limit ).ceil
    end
    
    # Return the limit that was passed or the default limit
    def limit
      @request.params[:limit] || 10
    end
    
    # Return the current page number
    def page
      @request.params[:page] ? @request.params[:page].to_i : 1
    end
    
    # Retrieve the next page
    def next_page
      page = self.page() + 1
      request = @request.clone()
      request.replace_param( :page, page )
      @client.execute( request )
    end
    
  end
end