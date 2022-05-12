module Mailosaur
  module Models
    class Device < BaseModel
      def initialize(data = {})
        @id = data['id']
        @name = data['name']
      end

      # @return [String] Unique identifier for the device.
      attr_accessor :id

      # @return [String] The name of the device.
      attr_accessor :name
    end
  end
end
