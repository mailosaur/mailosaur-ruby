module Mailosaur
  class Analysis
    #
    # Creates and initializes a new instance of the Analysis class.
    # @param conn client connection.
    #
    def initialize(conn, handle_http_error)
      @conn = conn
      @handle_http_error = handle_http_error
    end

    # @return [Connection] the client connection.
    attr_reader :conn

    #
    # Perform a spam test
    #
    # Perform spam testing on the specified email
    #
    # @param email The identifier of the email to be analyzed.
    #
    # @return [SpamAnalysisResult] operation results.
    #
    def spam(email)
      response = conn.get "api/analysis/spam/#{email}"
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::SpamAnalysisResult.new(model)
    end

    #
    # Perform a deliverability report
    #
    # Perform deliverability test on the specified email
    #
    # @param email The identifier of the email to be analyzed.
    #
    # @return [DeliverabilityReport] operation results.
    #
    def deliverability(email)
      response = conn.get "api/analysis/deliverability/#{email}"
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::DeliverabilityReport.new(model)
    end
  end
end
