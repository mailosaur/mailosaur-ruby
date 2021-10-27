module Mailosaur
  module Models
    class MessageForwardOptions < BaseModel
      def initialize(data = {})
        @to = data['to']
        @text = data['text']
        @html = data['html']
      end

      # @return [String] The email address to which the email will be sent. 
      # Must be a verified email address.
      attr_accessor :to

      # @return [String] Any additional plain text content to forward the
      # email with. Note that only text or html can be supplied, not both.
      attr_accessor :text

      # @return [String] Any additional HTML content to forward the email
      # with. Note that only html or text can be supplied, not both.
      attr_accessor :html
    end
  end
end
