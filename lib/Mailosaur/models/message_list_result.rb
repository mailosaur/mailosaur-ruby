module Mailosaur
  module Models
    class MessageListResult < BaseModel
      def initialize(data = {})
        @items = []
        (data['items'] || []).each do |i| @items << Mailosaur::Models::MessageSummary.new(i) end
      end

      # @return [Array<MessageSummary>] The individual summaries of each
      # message forming the result. Summaries are returned sorted by received
      # date, with the most recently-received messages appearing first.
      attr_accessor :items
    end
  end
end
