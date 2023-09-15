module Mailosaur
  module Models
    class PreviewEmailClientListResult < BaseModel
      def initialize(data = {})
        @items = []
        (data['items'] || []).each { |i| @items << Mailosaur::Models::PreviewEmailClient.new(i) }
      end

      # @return [Array<PreviewEmailClient>] A list of available email clients with which to generate email previews.
      # A list of available email clients.
      attr_accessor :items
    end
  end
end
