require "#{File.dirname(__FILE__)}/link"
require "#{File.dirname(__FILE__)}/image"


class EmailData
  attr_accessor :links, :body, :images

  def initialize(hash)
    @links =hash.has_key?('links') ? hash['links'].map { |a| Link.new(a) } : nil
    @body = hash['body']
    @images = hash.has_key?('images') ? hash['images'].map { |a| Image.new(a) } : nil
  end
end