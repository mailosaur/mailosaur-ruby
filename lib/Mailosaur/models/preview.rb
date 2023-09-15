module Mailosaur
  module Models
    class Preview < BaseModel
      def initialize(data = {})
        @id = data['id']
        @email_client = data['emailClient']
        @disable_images = data['disableImages']
      end

      # @return [String] Unique identifier for the email preview.
      attr_accessor :id

      # @return [String] The email client the preview was generated with.
      attr_accessor :email_client

      # @return [Boolean] True if images were disabled in the preview.
      attr_accessor :disable_images
    end
  end
end
