module Mailosaur
  module Models
    class UsageAccountLimits < BaseModel
      def initialize(data = {})
        @servers = Mailosaur::Models::UsageAccountLimit.new(data['servers'])
        @users = Mailosaur::Models::UsageAccountLimit.new(data['users'])
        @email = Mailosaur::Models::UsageAccountLimit.new(data['email'])
        @sms = Mailosaur::Models::UsageAccountLimit.new(data['sms'])
      end

      # @return [UsageAccountLimit]
      attr_accessor :servers

      # @return [UsageAccountLimit]
      attr_accessor :users

      # @return [UsageAccountLimit]
      attr_accessor :email

      # @return [UsageAccountLimit]
      attr_accessor :sms
    end
  end
end
