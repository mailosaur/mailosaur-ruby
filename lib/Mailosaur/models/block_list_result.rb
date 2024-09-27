module Mailosaur
  module Models
    class BlockListResult < BaseModel
      def initialize(data = {})
        @id = data['id']
        @name = data['name']
        @result = data['result']
      end

      # @return [String]
      attr_accessor :id
      # @return [String]
      attr_accessor :name
      # @return [String]
      attr_accessor :result
    end
  end
end
