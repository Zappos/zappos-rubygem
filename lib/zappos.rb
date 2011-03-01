require File.expand_path(File.dirname(__FILE__) + '/zappos/client')

module Zappos
  
  def self.client(key, options={})
    Zappos::Client.new(key, options)
  end
  
end