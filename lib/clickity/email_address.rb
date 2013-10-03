class EmailAddress
  attr_accessor :address, :name

  def initialize(hash)
    @address = hash['address']
    @name = hash['name']
  end
end

