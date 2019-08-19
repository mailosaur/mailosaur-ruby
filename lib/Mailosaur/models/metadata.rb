module Mailosaur
  module Models
    class Metadata < BaseModel
      def initialize(data = {})
        @headers = []
        (data['headers'] || []).each do |i| @headers << Mailosaur::Models::MessageHeader.new(i) end
      end

      # @return [Array<MessageHeader>] Email headers.
      attr_accessor :headers
    end
  end
end
