module Mailosaur
  module Models
    class Server < BaseModel
      def initialize(data = {})
        @id = data['id']
        @password = data['password']
        @name = data['name']
        @users = data['users']
        @messages = data['messages']
        @forwarding_rules = []
        (data['forwardingRules'] || []).each do |i| @forwarding_rules << Mailosaur::Models::ForwardingRule.new(i) end
      end

      # @return [String] Unique identifier for the server. Used as username for
      # SMTP/POP3 authentication.
      attr_accessor :id

      # @return [String] SMTP/POP3 password.
      attr_accessor :password

      # @return [String] A name used to identify the server.
      attr_accessor :name

      # @return Users (excluding administrators) who have access to the server.
      attr_accessor :users

      # @return [Integer] The number of messages currently in the server.
      attr_accessor :messages

      # @return [Array<ForwardingRule>] The rules used to manage email
      # forwarding for this server.
      attr_accessor :forwarding_rules
    end
  end
end
