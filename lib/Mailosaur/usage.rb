module Mailosaur
  # Operations for inspecting your account's usage limits and recent transactional usage.
  # These endpoints require authentication with an account-level API key. Accessed via +client.usage+.
  class Usage
    #
    # Creates and initializes a new instance of the Usage class.
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
    # Retrieve account usage limits. Details the current limits and usage for your account.
    # This endpoint requires authentication with an account-level API key.
    #
    # @return [Mailosaur::Models::UsageAccountLimits] The usage limits for your account.
    #
    def limits
      response = conn.get 'api/usage/limits'
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::UsageAccountLimits.new(model)
    end

    #
    # Retrieves the last 31 days of transactional usage.
    # This endpoint requires authentication with an account-level API key.
    #
    # @return [Mailosaur::Models::UsageTransactionListResult] The transactional usage for the last 31 days.
    #
    def transactions
      response = conn.get 'api/usage/transactions'
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::UsageTransactionListResult.new(model)
    end
  end
end
