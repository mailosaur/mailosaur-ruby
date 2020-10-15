module Mailosaur
  class Servers
    #
    # Creates and initializes a new instance of the Servers class.
    # @param client connection.
    #
    def initialize(conn, handle_http_error)
      @conn = conn
      @handle_http_error = handle_http_error
    end

    # @return [Connection] the client connection.
    attr_reader :conn

    #
    # List all servers
    #
    # Returns a list of your virtual SMTP servers. Servers are returned sorted in
    # alphabetical order.
    #
    # @return [ServerListResult] operation results.
    #
    def list
      response = conn.get 'api/servers'
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.load(response.body)
      Mailosaur::Models::ServerListResult.new(model)
    end

    #
    # Create a server
    #
    # Creates a new virtual SMTP server and returns it.
    #
    # @param server_create_options [ServerCreateOptions]
    #
    # @return [Server] operation results.
    #
    def create(server_create_options)
      response = conn.post 'api/servers', server_create_options.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.load(response.body)
      Mailosaur::Models::Server.new(model)
    end

    #
    # Retrieve a server
    #
    # Retrieves the detail for a single server. Simply supply the unique identifier
    # for the required server.
    #
    # @param id [String] The identifier of the server to be retrieved.
    #
    # @return [Server] operation results.
    #
    def get(id)
      response = conn.get 'api/servers/' + id
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.load(response.body)
      Mailosaur::Models::Server.new(model)
    end

    #
    # Update a server
    #
    # Updats a single server and returns it.
    #
    # @param id [String] The identifier of the server to be updated.
    # @param server [Server]
    #
    # @return [Server] operation results.
    #
    def update(id, server)
      response = conn.put 'api/servers/' + id, server.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.load(response.body)
      Mailosaur::Models::Server.new(model)
    end

    #
    # Delete a server
    #
    # Permanently deletes a server. This operation cannot be undone. Also deletes
    # all messages and associated attachments within the server.
    #
    # @param id [String] The identifier of the server to be deleted.
    #
    def delete(id)
      response = conn.delete 'api/servers/' + id
      @handle_http_error.call(response) unless response.status == 204
      nil
    end

    def generate_email_address(server)
      host = ENV['MAILOSAUR_SMTP_HOST'] || 'mailosaur.io'
      '%s.%s@%s' % [SecureRandom.hex(3), server, host]
    end
  end
end
