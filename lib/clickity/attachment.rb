class Attachment
  attr_accessor :contentType, :fileName, :length, :id

  def initialize(hash)
    @contentType = hash['contentType']
    @fileName = hash['fileName']
    @length = hash['length']
    @id = hash['id']
  end
end
