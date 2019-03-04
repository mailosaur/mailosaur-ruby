module Mailosaur
  module Models
    class ForwardingRule < BaseModel
      def initialize(data = {})
        @field = data['field']
        @operator = data['operator']
        @value = data['value']
        @forward_to = data['forwardTo']
      end

      # @return [Enum] Possible values include: 'from', 'to', 'subject'
      attr_accessor :field

      # @return [Enum] Possible values include: 'endsWith', 'startsWith',
      # 'contains'
      attr_accessor :operator

      # @return [String]
      attr_accessor :value

      # @return [String]
      attr_accessor :forward_to
    end
  end
end
