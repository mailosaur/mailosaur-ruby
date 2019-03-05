module Mailosaur
  module Models
    class ServerCreateOptions < BaseModel
      def initialize(data = {})
        @name = data['name']
      end

      # @return [String] A name used to identify the server.
      attr_accessor :name
    end
  end
end
