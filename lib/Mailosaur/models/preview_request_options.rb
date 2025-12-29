module Mailosaur
  module Models
    class PreviewRequestOptions < BaseModel
      def initialize(email_clients)
        @email_clients = email_clients
      end

      # @return [Array<String>] The list email clients to generate previews with.
      attr_accessor :email_clients
    end
  end
end
