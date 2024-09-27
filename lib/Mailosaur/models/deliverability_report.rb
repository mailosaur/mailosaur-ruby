module Mailosaur
  module Models
    class DeliverabilityReport < BaseModel
      def initialize(data = {})
        @spf = Mailosaur::Models::EmailAuthenticationResult.new(data['spf'])
        @dkim = []
        (data['dkim'] || []).each { |i| @dkim << Mailosaur::Models::EmailAuthenticationResult.new(i) }
        @dmarc = Mailosaur::Models::EmailAuthenticationResult.new(data['dmarc'])
        @block_lists = []
        (data['blockLists'] || []).each { |i| @block_lists << Mailosaur::Models::BlockListResult.new(i) }
        @content = Mailosaur::Models::Content.new(data['content'])
        @dns_records = Mailosaur::Models::DnsRecords.new(data['dnsRecords'])
        @spam_assassin = Mailosaur::Models::SpamAssassinResult.new(data['spamAssassin'])
      end

      # @return [EmailAuthenticationResult]
      attr_accessor :spf
      # @return [Array<EmailAuthenticationResult>]
      attr_accessor :dkim
      # @return [EmailAuthenticationResult]
      attr_accessor :dmarc
      # @return [Array<BlockListResult>]
      attr_accessor :block_lists
      # @return [Content]
      attr_accessor :content
      # @return [DnsRecords]
      attr_accessor :dns_records
      # @return [SpamAssassinResult]
      attr_accessor :spam_assassin
    end
  end
end
