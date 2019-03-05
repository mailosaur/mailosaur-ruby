module Mailosaur
  module Models
    class SpamAnalysisResult < BaseModel
      def initialize(data = {})
        @spam_filter_results = Mailosaur::Models::SpamFilterResults.new(data['spamFilterResults'])
        @score = data['score']
      end

       attr_accessor :spam_filter_results

      # @return [Float]
      attr_accessor :score
    end
  end
end
