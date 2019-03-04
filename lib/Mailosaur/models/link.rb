module Mailosaur
  module Models
    class Link < BaseModel
      def initialize(data = {})
        @href = data['href']
        @text = data['text']
      end

      # @return [String]
      attr_accessor :href

      # @return [String]
      attr_accessor :text
    end
  end
end
