module Mailosaur
  module Models
    class Attachment < BaseModel
      def initialize(data = {})
        @id = data['id']
        @content_type = data['contentType']
        @file_name = data['fileName']
        @content_id = data['contentId']
        @length = data['length']
        @url = data['url']
      end

      # @return
      attr_accessor :id

      # @return [String]
      attr_accessor :content_type

      # @return [String]
      attr_accessor :file_name

      # @return [String]
      attr_accessor :content_id

      # @return [Integer]
      attr_accessor :length

      # @return [String]
      attr_accessor :url
    end
  end
end
