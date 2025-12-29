module Mailosaur
  module Models
    class EmailClientListResult < BaseModel
      def initialize(data = {})
        @items = []
        (data['items'] || []).each { |i| @items << Mailosaur::Models::EmailClient.new(i) }
      end

      # @return [Array<EmailClient>] A list of available email clients with which to generate email previews.
      attr_accessor :items
    end
  end
end
