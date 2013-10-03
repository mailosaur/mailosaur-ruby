require "#{File.dirname(__FILE__)}/link"

class EmailData
  attr_accessor :links, :body

  def initialize(hash)
    @links =hash.has_key?('links') ? hash['links'].map { |a| Link.new(a) } : nil
    @body = hash['body']
  end
end