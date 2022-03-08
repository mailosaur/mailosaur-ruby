module Mailosaur
  module Models
    class Code < BaseModel
      def initialize(data = {})
        @value = data['value']
      end

      # @return [String]
      attr_accessor :value
    end
  end
end
