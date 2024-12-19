module Mailosaur
  module Models
    class MessageReplyOptions < BaseModel
      def initialize(data = {})
        @cc = data['cc']
        @text = data['text']
        @html = data['html']
        @attachments = data['attachments']
      end

      # @return [String] The email address to which the email will be CC'd.
      # Must be a verified email address.
      attr_accessor :cc

      # @return [String] Any additional plain text content to include in
      # the reply. Note that only text or html can be supplied, not both.
      attr_accessor :text

      # @return [String] Any additional HTML content to include in the
      # reply. Note that only html or text can be supplied, not both.
      attr_accessor :html

      # @return [Array<Attachment>] Any message attachments.
      attr_accessor :attachments
    end
  end
end
