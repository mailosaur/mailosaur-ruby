require 'json'

module Mailosaur
  class MailosaurError < StandardError
    attr_reader :type
    attr_reader :messages
    attr_reader :model

    def initialize(message, error_model)
      super(message)

      @type = nil
      @messages = nil
      @model = nil

      unless error_model.nil?
        @type = error_model['type']
        @messages = error_model['messages']
        @model = error_model['model']
      end
    end
  end
end
