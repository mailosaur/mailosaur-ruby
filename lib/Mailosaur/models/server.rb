module Mailosaur
  module Models
    class Server < BaseModel
      def initialize(data = {})
        @id = data['id']
        @password = data['password']
        @name = data['name']
        @users = data['users']
        @messages = data['messages']
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
    end
  end
end
