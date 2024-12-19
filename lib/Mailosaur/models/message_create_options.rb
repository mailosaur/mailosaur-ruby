module Mailosaur
  module Models
    class MessageCreateOptions < BaseModel
      def initialize(data = {})
        @to = data['to']
        @cc = data['cc']
        @from = data['from']
        @send = data['send']
        @subject = data['subject']
        @text = data['text']
        @html = data['html']
        @attachments = data['attachments']
      end

      # @return [String] The email address to which the email will be sent.
      # Must be a verified email address.
      attr_accessor :to

      # @return [String] The email address to which the email will be CC'd.
      # Must be a verified email address.
      attr_accessor :cc

      # @return [String] Allows for the partial override of the message's
      # 'from' address. This **must** be an address ending with
      # `YOUR_SERVER.mailosaur.net`, such as `my-emails@a1bcdef2.mailosaur.net`.
      attr_accessor :from

      # @return [Boolean] If true, email will be sent upon creation.
      attr_accessor :send

      # @return [String] The email subject line.
      attr_accessor :subject

      # @return [String] The plain text body of the email. Note that only
      # text or html can be supplied, not both.
      attr_accessor :text

      # @return [String] The HTML body of the email. Note that only text
      # or html can be supplied, not both.
      attr_accessor :html

      # @return [Array<Attachment>] Any message attachments.
      attr_accessor :attachments
    end
  end
end
