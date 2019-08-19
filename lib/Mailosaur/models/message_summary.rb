module Mailosaur
  module Models
    class MessageSummary < BaseModel
      def initialize(data = {})
        @id = data['id']
        @server = data['server']
        @rcpt = []
        (data['rcpt'] || []).each do |i| @rcpt << Mailosaur::Models::MessageAddress.new(i) end
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
        @summary = data['summary']
        @attachments = data['attachments']
      end

      # @return
      attr_accessor :id

      # @return [String]
      attr_accessor :server

      # @return [Array<MessageAddress>]
      attr_accessor :rcpt

      # @return [Array<MessageAddress>]
      attr_accessor :from

      # @return [Array<MessageAddress>]
      attr_accessor :to

      # @return [Array<MessageAddress>]
      attr_accessor :cc

      # @return [Array<MessageAddress>]
      attr_accessor :bcc

      # @return [DateTime]
      attr_accessor :received

      # @return [String]
      attr_accessor :subject

      # @return [String]
      attr_accessor :summary

      # @return [Integer]
      attr_accessor :attachments
    end
  end
end
