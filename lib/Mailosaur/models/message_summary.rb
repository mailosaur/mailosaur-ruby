module Mailosaur
  module Models
    class MessageSummary < BaseModel
      def initialize(data = {})
        @id = data['id']
        @type = data['type']
        @server = data['server']
        @from = []
        (data['from'] || []).each { |i| @from << Mailosaur::Models::MessageAddress.new(i) }
        @to = []
        (data['to'] || []).each { |i| @to << Mailosaur::Models::MessageAddress.new(i) }
        @cc = []
        (data['cc'] || []).each { |i| @cc << Mailosaur::Models::MessageAddress.new(i) }
        @bcc = []
        (data['bcc'] || []).each { |i| @bcc << Mailosaur::Models::MessageAddress.new(i) }
        @received = DateTime.parse(data['received'])
        @subject = data['subject']
        @summary = data['summary']
        @attachments = data['attachments']
      end

      # @return
      attr_accessor :id

      # @return
      attr_accessor :type

      # @return [String]
      attr_accessor :server

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
