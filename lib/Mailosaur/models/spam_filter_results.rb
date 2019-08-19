module Mailosaur
  module Models
    class SpamFilterResults < BaseModel
      def initialize(data = {})
        @spam_assassin = []
        (data['spamAssassin'] || []).each do |i| @spam_assassin << Mailosaur::Models::SpamAssassinRule.new(i) end
      end

      # @return [Array<SpamAssassinRule>]
      attr_accessor :spam_assassin
    end
  end
end
