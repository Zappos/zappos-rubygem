module Patron
  
  def self.client(options={})
    Patron::Client.new(options)
  end
  
end