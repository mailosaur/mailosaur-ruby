module Mailosaur
  module Models
    class PreviewEmailClient < BaseModel
      def initialize(data = {})
        @id = data['id']
        @name = data['name']
        @platform_group = data['platformGroup']
        @platform_type = data['platformType']
        @platform_version = data['platformVersion']
        @can_disable_images = data['canDisableImages']
        @status = data['status']
      end

      # @return [String] Unique identifier for the email preview.
      attr_accessor :id

      # @return [String] The display name of the email client.
      attr_accessor :name

      # @return [String] Whether the platform is desktop, mobile, or web-based.
      attr_accessor :platform_group

      # @return [String] The type of platform on which the email client is running.
      attr_accessor :platform_type

      # @return [String] The platform version number.
      attr_accessor :platform_version

      # @return [Boolean] If true, images can be disabled when generating previews.
      attr_accessor :can_disable_images

      # @return [String] The current status of the email client.
      attr_accessor :status
    end
  end
end
