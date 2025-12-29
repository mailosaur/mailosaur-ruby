module Mailosaur
  class Previews
    #
    # Creates and initializes a new instance of the Previews class.
    # @param client connection.
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
    # Returns a list of available email clients.
    #
    # @return [EmailClientListResult] operation results.
    #
    def list_email_clients
      response = conn.get 'api/screenshots/clients'
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::EmailClientListResult.new(model)
    end
  end
end
