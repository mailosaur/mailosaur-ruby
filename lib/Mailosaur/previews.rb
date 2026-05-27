module Mailosaur
  # Operations for discovering the email clients available for generating email previews
  # (screenshots of an email rendered in real clients). Accessed via +client.previews+.
  class Previews
    #
    # Creates and initializes a new instance of the Previews class.
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
    # List all email clients that can be used to generate email previews.
    #
    # @return [Mailosaur::Models::EmailClientListResult] The available email clients.
    #
    def list_email_clients
      response = conn.get 'api/screenshots/clients'
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::EmailClientListResult.new(model)
    end
  end
end
