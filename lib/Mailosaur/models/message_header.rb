module Mailosaur
  module Models
    class MessageHeader < BaseModel
      def initialize(data = {})
        @field = data['field']
        @value = data['value']
      end

      # @return [String] Header key.
      attr_accessor :field

      # @return [String] Header value.
      attr_accessor :value
    end
  end
end
