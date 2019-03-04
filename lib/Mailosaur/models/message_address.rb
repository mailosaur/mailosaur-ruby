module Mailosaur
  module Models
    class MessageAddress < BaseModel
      def initialize(data = {})
        @name = data['name']
        @email = data['email']
        @phone = data['phone']
      end

      # @return [String] Display name, if one is specified.
      attr_accessor :name

      # @return [String] Email address (applicable to email messages).
      attr_accessor :email

      # @return [String] Phone number (applicable to SMS messages).
      attr_accessor :phone
    end
  end
end
