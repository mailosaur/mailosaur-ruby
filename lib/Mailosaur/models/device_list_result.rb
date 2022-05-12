module Mailosaur
  module Models
    class DeviceListResult < BaseModel
      def initialize(data = {})
        @items = []
        (data['items'] || []).each { |i| @items << Mailosaur::Models::Device.new(i) }
      end

      # @return [Array<Device>] The individual devices forming the result.
      attr_accessor :items
    end
  end
end
