module Mailosaur
  module Models
    class PreviewListResult < BaseModel
      def initialize(data = {})
        @items = []
        (data['items'] || []).each { |i| @items << Mailosaur::Models::Preview.new(i) }
      end

      # @return [Array<Preview>] A list of requested email previews.
      # The summaries for each requested preview.
      attr_accessor :items
    end
  end
end
