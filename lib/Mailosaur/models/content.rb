module Mailosaur
  module Models
    class Content < BaseModel
      def initialize(data = {})
        @embed = data['embed']
        @iframe = data['iframe']
        @object = data['object']
        @script = data['script']
        @short_urls = data['shortUrls']
        @text_size = data['textSize']
        @total_size = data['totalSize']
        @missing_alt = data['missingAlt']
        @missing_list_unsubscribe = data['missingListUnsubscribe']
      end

      # @return [Boolean]
      attr_accessor :embed
      # @return [Boolean]
      attr_accessor :iframe
      # @return [Boolean]
      attr_accessor :object
      # @return [Boolean]
      attr_accessor :script
      # @return [Boolean]
      attr_accessor :short_urls
      # @return [Integer]
      attr_accessor :text_size
      # @return [Integer]
      attr_accessor :total_size
      # @return [Boolean]
      attr_accessor :missing_alt
      # @return [Boolean]
      attr_accessor :missing_list_unsubscribe
    end
  end
end
