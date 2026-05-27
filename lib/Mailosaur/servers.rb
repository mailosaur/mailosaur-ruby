module Mailosaur
  # Operations for creating and managing your Mailosaur inboxes (servers) — they
  # group your tests together, each with its own domain and SMTP/POP3/IMAP credentials.
  # Accessed via +client.servers+.
  class Servers
    #
    # Creates and initializes a new instance of the Servers class.
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
    # Returns a list of your inboxes (servers). Inboxes (servers) are returned sorted in
    # alphabetical order.
    #
    # @return [Mailosaur::Models::ServerListResult] Your inboxes (servers).
    #
    def list
      response = conn.get 'api/servers'
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::ServerListResult.new(model)
    end

    #
    # Creates a new inbox (server).
    #
    # @param server_create_options [Mailosaur::Models::ServerCreateOptions] Options used to
    #   create a new Mailosaur inbox (server).
    #
    # @return [Mailosaur::Models::Server] The newly-created inbox (server).
    #
    def create(server_create_options)
      response = conn.post 'api/servers', server_create_options.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::Server.new(model)
    end

    #
    # Retrieves the detail for a single inbox (server).
    #
    # @param id [String] The unique identifier of the inbox (server).
    #
    # @return [Mailosaur::Models::Server] The inbox (server).
    #
    def get(id)
      response = conn.get "api/servers/#{id}"
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::Server.new(model)
    end

    #
    # Retrieves the password for an inbox (server). This password can be used for SMTP, POP3, and
    # IMAP connectivity.
    #
    # @param id [String] The unique identifier of the inbox (server).
    #
    # @return [String] The password for the inbox (server).
    #
    def get_password(id)
      response = conn.get "api/servers/#{id}/password"
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      model['value']
    end

    #
    # Updates the attributes of an inbox (server).
    #
    # @param id [String] The unique identifier of the inbox (server).
    # @param server [Mailosaur::Models::Server] The updated inbox (server).
    #
    # @return [Mailosaur::Models::Server] The updated inbox (server).
    #
    def update(id, server)
      response = conn.put "api/servers/#{id}", server.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::Server.new(model)
    end

    #
    # Permanently delete an inbox (server). This will also delete all messages, associated attachments,
    # etc. within the inbox (server). This operation cannot be undone.
    #
    # @param id [String] The unique identifier of the inbox (server).
    #
    # @return [nil] Once the inbox (server) has been deleted.
    #
    def delete(id)
      response = conn.delete "api/servers/#{id}"
      @handle_http_error.call(response) unless response.status == 204
      nil
    end

    #
    # Generates a random email address by appending a random string in front of the
    # domain name of the inbox (server).
    #
    # @param server [String] The identifier of the inbox (server).
    #
    # @return [String] A random email address ending in the domain of the inbox (server).
    #
    def generate_email_address(server)
      host = ENV['MAILOSAUR_SMTP_HOST'] || 'mailosaur.net'
      format('%s@%s.%s', SecureRandom.hex(3), server, host)
    end
  end
end
