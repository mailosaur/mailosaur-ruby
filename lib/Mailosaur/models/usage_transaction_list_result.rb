module Mailosaur
  module Models
    class UsageTransactionListResult < BaseModel
      def initialize(data = {})
        @items = []
        (data['items'] || []).each do |i| @items << Mailosaur::Models::UsageTransaction.new(i) end
      end

      # @return [Array<UsageTransaction>] The individual transactions the result.
      attr_accessor :items
    end
  end
end
