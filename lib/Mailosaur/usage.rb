module Mailosaur
  class Usage
    #
    # Creates and initializes a new instance of the Usage class.
    # @param client connection.
    #
    def initialize(conn, handle_http_error)
      @conn = conn
      @handle_http_error = handle_http_error
    end

    # @return [Connection] the client connection.
    attr_reader :conn

    #
    # Retrieve account usage limits.
    #
    # Details the current limits and usage for your account.
    #
    # @return [UsageAccountLimits] operation results.
    #
    def limits
      response = conn.get 'api/usage/limits'
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::UsageAccountLimits.new(model)
    end

    #
    # List account transactions. Retrieves the last 31 days of transactional usage.
    #
    # @return [UsageTransactionListResult] operation results.
    #
    def transactions
      response = conn.get 'api/usage/transactions'
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::UsageTransactionListResult.new(model)
    end
  end
end
