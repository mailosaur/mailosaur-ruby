module Mailosaur
  module Models
    class EmailAuthenticationResult < BaseModel
      def initialize(data = {})
        @result = data['result']
        @description = data['description']
        @raw_value = data['rawValue']
        @tags = data['tags']
      end

      # @return [String]
      attr_accessor :result
      # @return [String]
      attr_accessor :description
      # @return [String]
      attr_accessor :raw_value
      # @return [Hash<String,String>]
      attr_accessor :tags
    end
  end
end
