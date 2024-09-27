module Mailosaur
  module Models
    class DnsRecords < BaseModel
      def initialize(data = {})
        @a = data['a']
        @mx = data['mx']
        @ptr = data['ptr']
      end

      # @return [Array<String>]
      attr_accessor :a
      # @return [Array<String>]
      attr_accessor :mx
      # @return [Array<String>]
      attr_accessor :ptr
    end
  end
end
