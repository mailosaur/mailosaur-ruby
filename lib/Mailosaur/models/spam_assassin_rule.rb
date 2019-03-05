module Mailosaur
  module Models
    class SpamAssassinRule < BaseModel
      def initialize(data = {})
        @score = data['score']
        @rule = data['rule']
        @description = data['description']
      end

      # @return [Float]
      attr_accessor :score

      # @return [String]
      attr_accessor :rule

      # @return [String]
      attr_accessor :description
    end
  end
end
