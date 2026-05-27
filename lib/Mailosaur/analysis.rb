module Mailosaur
  # Operations for analyzing the content and deliverability of an email, including SpamAssassin
  # scoring and per-provider deliverability reports. Accessed via +client.analysis+.
  class Analysis
    #
    # Creates and initializes a new instance of the Analysis class.
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
    # Perform a spam analysis of an email.
    #
    # @param email [String] The identifier of the message to be analyzed.
    #
    # @return [Mailosaur::Models::SpamAnalysisResult] The spam score and filter results.
    #
    def spam(email)
      response = conn.get "api/analysis/spam/#{email}"
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::SpamAnalysisResult.new(model)
    end

    #
    # Perform a deliverability report of an email.
    #
    # @param email [String] The identifier of the message to be analyzed.
    #
    # @return [Mailosaur::Models::DeliverabilityReport] The deliverability report for the email.
    #
    def deliverability(email)
      response = conn.get "api/analysis/deliverability/#{email}"
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::DeliverabilityReport.new(model)
    end
  end
end
