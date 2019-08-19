module Mailosaur
  module Models
    class Message < BaseModel
      def initialize(data = {})
        @id = data['id']
        @from = []
        (data['from'] || []).each do |i| @from << Mailosaur::Models::MessageAddress.new(i) end
        @to = []
        (data['to'] || []).each do |i| @to << Mailosaur::Models::MessageAddress.new(i) end
        @cc = []
        (data['cc'] || []).each do |i| @cc << Mailosaur::Models::MessageAddress.new(i) end
        @bcc = []
        (data['bcc'] || []).each do |i| @bcc << Mailosaur::Models::MessageAddress.new(i) end
        @received = DateTime.parse(data['received'])
        @subject = data['subject']
        @html = Mailosaur::Models::MessageContent.new(data['html'])
        @text = Mailosaur::Models::MessageContent.new(data['text'])
        @attachments = []
        (data['attachments'] || []).each do |i| @attachments << Mailosaur::Models::Attachment.new(i) end
        @metadata = Mailosaur::Models::Metadata.new(data['metadata'])
        @server = data['server']
      end

      # @return Unique identifier for the message.
      attr_accessor :id

      # @return [Array<MessageAddress>] The sender of the message.
      attr_accessor :from

      # @return [Array<MessageAddress>] The message’s recipient.
      attr_accessor :to

      # @return [Array<MessageAddress>] Carbon-copied recipients for email
      # messages.
      attr_accessor :cc

      # @return [Array<MessageAddress>] Blind carbon-copied recipients for
      # email messages.
      attr_accessor :bcc

      # @return [DateTime] The datetime that this message was received by
      # Mailosaur.
      attr_accessor :received

      # @return [String] The message’s subject.
      attr_accessor :subject

      # @return [MessageContent] Message content that was sent in HTML format.
      attr_accessor :html

      # @return [MessageContent] Message content that was sent in plain text
      # format.
      attr_accessor :text

      # @return [Array<Attachment>] An array of attachment metadata for any
      # attached files.
      attr_accessor :attachments

      # @return [Metadata]
      attr_accessor :metadata

      # @return [String] Identifier for the server in which the message is
      # located.
      attr_accessor :server
    end
  end
end
