module Mailosaur
  module Models
    class SpamAssassinResult < BaseModel
      def initialize(data = {})
        @score = data['score']
        @result = data['result']
        @rules = []
        (data['rules'] || []).each { |i| @rules << Mailosaur::Models::SpamAssassinRule.new(i) }
      end

      attr_accessor :spam_filter_results

      # @return [Float]
      attr_accessor :score
      # @return [String]
      attr_accessor :result
      # @return [Array<SpamAssassinRule>]
      attr_accessor :rules
    end
  end
end
