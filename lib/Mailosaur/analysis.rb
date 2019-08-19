module Mailosaur
  class Analysis
    #
    # Creates and initializes a new instance of the Analysis class.
    # @param conn client connection.
    #
    def initialize(conn)
      @conn = conn
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
      response = conn.get 'api/analysis/spam/' + email

      unless response.status == 200
        error_model = JSON.load(response.body)
        mailosaur_error = Mailosaur::MailosaurError.new('Operation returned an invalid status code \'' + response.status.to_s + '\'', error_model)
        raise mailosaur_error
      end

      model = JSON.load(response.body)
      Mailosaur::Models::SpamAnalysisResult.new(model)
    end
  end
end
