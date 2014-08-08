class Image
  attr_accessor :src, :alt

  def initialize(hash)
    @src = hash['src']
    @alt = hash['alt']
  end
end
