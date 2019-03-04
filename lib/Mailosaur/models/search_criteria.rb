module Mailosaur
  module Models
    class SearchCriteria < BaseModel
      def initialize(data = {})
        @sent_to = data['sentTo']
        @subject = data['subject']
        @body = data['body']
      end

      # @return [String] The full email address to which the target email was
      # sent.
      attr_accessor :sent_to

      # @return [String] The value to seek within the target email's subject
      # line.
      attr_accessor :subject

      # @return [String] The value to seek within the target email's HTML or
      # text body.
      attr_accessor :body
    end
  end
end
