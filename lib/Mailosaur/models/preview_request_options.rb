module Mailosaur
  module Models
    class PreviewRequestOptions < BaseModel
      def initialize(previews)
        @previews = previews
      end

      # @return [PreviewRequest] The list of email preview requests.
      attr_accessor :previews
    end
  end
end
