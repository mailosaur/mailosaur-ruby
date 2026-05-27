module Mailosaur
  # Operations for downloading the raw content associated with a message — file attachments,
  # the full EML source of an email, and rendered email previews. Accessed via +client.files+.
  class Files
    #
    # Creates and initializes a new instance of the Files class.
    # @param conn [Faraday::Connection] The client connection.
    # @param handle_http_error [Method] Callback used to convert HTTP error responses into errors.
    #
    def initialize(conn, handle_http_error)
      @conn = conn
      @handle_http_error = handle_http_error
    end

    # @return [Connection] the client connection.
    attr_reader :conn

    #
    # Downloads a single attachment.
    #
    # @param id [String] The identifier for the required attachment.
    #
    # @return [String] The attachment's binary content.
    #
    def get_attachment(id)
      response = conn.get "api/files/attachments/#{id}"
      @handle_http_error.call(response) unless response.status == 200
      response.body
    end

    #
    # Downloads an EML file representing the specified email.
    #
    # @param id [String] The identifier for the required message.
    #
    # @return [String] The raw EML content of the email.
    #
    def get_email(id)
      response = conn.get "api/files/email/#{id}"
      @handle_http_error.call(response) unless response.status == 200
      response.body
    end

    #
    # Downloads a screenshot of your email rendered in a real email client. Simply supply
    # the unique identifier for the required preview.
    #
    # @param id [String] The identifier of the email preview to be downloaded.
    #
    # @return [String] The preview screenshot image content.
    #
    # @raise [Mailosaur::MailosaurError] With error code +preview_timeout+ if the preview is
    #   not generated within the time limit.
    #
    def get_preview(id)
      timeout = 120_000
      poll_count = 0
      start_time = Time.now.to_f

      loop do
        response = conn.get "api/files/screenshots/#{id}"

        return response.body if response.status == 200

        @handle_http_error.call(response) unless response.status == 202

        delay_pattern = (response.headers['x-ms-delay'] || '1000').split(',').map(&:to_i)

        delay = poll_count >= delay_pattern.length ? delay_pattern[delay_pattern.length - 1] : delay_pattern[poll_count]

        poll_count += 1

        ## Stop if timeout will be exceeded
        if ((1000 * (Time.now.to_f - start_time).to_i) + delay) > timeout
          msg = format('An email preview was not generated in time. The email client may not be available, or the preview ID [%s] may be incorrect.', id)
          raise Mailosaur::MailosaurError.new(msg, 'preview_timeout')
        end

        sleep(delay / 1000.0)
      end
    end
  end
end
