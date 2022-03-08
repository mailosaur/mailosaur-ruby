module Mailosaur
  module Models
    class MessageContent < BaseModel
      def initialize(data = {})
        @links = []
        (data['links'] || []).each do |i| @links << Mailosaur::Models::Link.new(i) end
        @codes = []
        (data['codes'] || []).each do |i| @codes << Mailosaur::Models::Code.new(i) end
        @images = []
        (data['images'] || []).each do |i| @images << Mailosaur::Models::Image.new(i) end
        @body = data['body']
      end

      # @return [Array<Link>]
      attr_accessor :links

      # @return [Array<Code>]
      attr_accessor :codes

      # @return [Array<Image>]
      attr_accessor :images

      # @return [String]
      attr_accessor :body
    end
  end
end
