module Mailosaur
  module Models
    class PreviewRequest < BaseModel
      def initialize(email_client, disable_images: false)
        @email_client = email_client
        @disable_images = disable_images
      end

      # @return [String] The email client the preview was generated with.
      attr_accessor :email_client

      # @return [Boolean] True if images were disabled in the preview.
      attr_accessor :disable_images
    end
  end
end
