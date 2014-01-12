class Link
  attr_accessor :href, :text, :content, :headers, :code

  def initialize(hash)
    @href = hash['href']
    @text = hash['text']
    @content = hash['content']
    @headers = hash['headers']
    @code = hash['code']
  end
end
