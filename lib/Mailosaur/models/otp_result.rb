module Mailosaur
  module Models
    class OtpResult < BaseModel
      def initialize(data = {})
        @code = data['code']
        @expires = data['expires']
      end

      # @return [String] The current one-time password.
      attr_accessor :code

      # @return [String] The expiry date/time of the current one-time password.
      attr_accessor :expires
    end
  end
end
