require "#{File.dirname(__FILE__)}/Link"

class EmailData
  attr_accessor :links, :body

  def initialize(hash)
    @links = hash['links']
    @links =hash.has_key?('links') ? hash['links'].map { |a| Link.new(a) } : nil
    @body = hash['body']
  end
end