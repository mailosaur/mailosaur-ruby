module Mailosaur
  module Models
    class DeviceCreateOptions < BaseModel
      def initialize(data = {})
        @name = data['name']
        @shared_secret = data['shared_secret']
      end

      # @return [String] A name used to identify the device.
      attr_accessor :name

      # @return [String] The base32-encoded shared secret for this device.
      attr_accessor :shared_secret
    end
  end
end
