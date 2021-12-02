module Mailosaur
  module Models
    class Metadata < BaseModel
      def initialize(data = {})
        @headers = []
        (data['headers'] || []).each do |i| @headers << Mailosaur::Models::MessageHeader.new(i) end

        @ehlo = data['ehlo']
        
        @mail_from = data['mailFrom']

        @rcpt_to = []
        (data['rcptTo'] || []).each do |i| @rcpt_to << Mailosaur::Models::MessageAddress.new(i) end
      end

      # @return [Array<MessageHeader>] Email headers.
      attr_accessor :headers

      # @return [String] The fully-qualified domain name or IP address that was provided with the
      # Extended HELLO (EHLO) or HELLO (HELO) command. This value is generally
      # used to identify the SMTP client.
      # https://datatracker.ietf.org/doc/html/rfc5321#section-4.1.1.1
      attr_accessor :ehlo

      # @return [String] The source mailbox/email address, referred to as the 'reverse-path',
      # provided via the MAIL command during the SMTP transaction.
      # https://datatracker.ietf.org/doc/html/rfc5321#section-4.1.1.2
      attr_accessor :mail_from

      # @return [Array<MessageAddress>] The recipient email addresses, each referred to as a 'forward-path',
      # provided via the RCPT command during the SMTP transaction.
      # https://datatracker.ietf.org/doc/html/rfc5321#section-4.1.1.3
      attr_accessor :rcpt_to
    end
  end
end
