module Mailosaur
  class MailosaurError < StandardError
    attr_reader :error_type, :http_status_code, :http_response_body

    def initialize(message = '', error_type = '', http_status_code = nil, http_response_body = nil)
      super(message)

      @error_type = error_type
      @http_status_code = http_status_code
      @http_response_body = http_response_body
    end
  end
end
