module Mailosaur
  module Models
    class Server < BaseModel
      def initialize(data = {})
        @id = data['id']
        @name = data['name']
        @users = data['users']
        @messages = data['messages']
      end

      # @return [String] Unique identifier for the inbox (server). Used as username for
      # SMTP/POP3 authentication.
      attr_accessor :id

      # @return [String] A name used to identify the inbox (server).
      attr_accessor :name

      # @return Users (excluding administrators) who have access to the inbox (server) when access is restricted.
      attr_accessor :users

      # @return [Integer] The number of messages currently in the inbox (server).
      attr_accessor :messages
    end
  end
end
