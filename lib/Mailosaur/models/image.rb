module Mailosaur
  module Models
    class Image < BaseModel
      def initialize(data = {})
        @src = data['src']
        @alt = data['alt']
      end

      # @return [String]
      attr_accessor :src

      # @return [String]
      attr_accessor :alt
    end
  end
end
