module Mailosaur
  module Models
    class UsageAccountLimit < BaseModel
      def initialize(data = {})
        @limit = data['limit']
        @current = data['current']
      end

      # @return [Integer] The limit.
      attr_accessor :limit

      # @return [Integer] The current usage.
      attr_accessor :current
    end
  end
end
