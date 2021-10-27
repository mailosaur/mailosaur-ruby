module Mailosaur
  module Models
    class MessageReplyOptions < BaseModel
      def initialize(data = {})
        @text = data['text']
        @html = data['html']
      end

      # @return [String] Any additional plain text content to include in
      # the reply. Note that only text or html can be supplied, not both.
      attr_accessor :text

      # @return [String] Any additional HTML content to include in the
      # reply. Note that only html or text can be supplied, not both.
      attr_accessor :html
    end
  end
end
