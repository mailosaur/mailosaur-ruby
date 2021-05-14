module Mailosaur
  module Models
    class UsageTransaction < BaseModel
      def initialize(data = {})
        @timestamp = DateTime.parse(data['timestamp'])
        @email = data['email']
        @sms = data['sms']
      end

      # @return [DateTime] The datetime that this transaction occurred.
      attr_accessor :timestamp

      # @return [Integer] The count of emails.
      attr_accessor :email

      # @return [Integer] The count of SMS messages.
      attr_accessor :sms
    end
  end
end
