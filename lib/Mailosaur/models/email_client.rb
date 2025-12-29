module Mailosaur
  module Models
    class EmailClient < BaseModel
      def initialize(data = {})
        @label = data['label']
        @name = data['name']
      end

      # @return [String] The unique email client label. Used when generating email preview requests.
      attr_accessor :label

      # @return [String] The display name of the email client.
      attr_accessor :name
    end
  end
end
