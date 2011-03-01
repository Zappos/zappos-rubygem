require File.expand_path(File.dirname(__FILE__) + '/patron/client')

module Patron
  
  def self.client(key, options={})
    Patron::Client.new(key, options)
  end
  
end