module Mailosaur
  class Files
    #
    # Creates and initializes a new instance of the Files class.
    # @param client connection.
    #
    def initialize(conn)
      @conn = conn
    end

    # @return [Connection] the client connection.
    attr_reader :conn

    #
    # Download an attachment
    #
    # Downloads a single attachment. Simply supply the unique identifier for the
    # required attachment.
    #
    # @param id The identifier of the attachment to be downloaded.
    #
    # @return [NOT_IMPLEMENTED] operation results.
    #
    def get_attachment(id)
      response = conn.get 'api/files/attachments/' + id

      unless response.status == 200
        error_model = JSON.load(response.body)
        mailosaur_error = Mailosaur::MailosaurError.new('Operation returned an invalid status code \'' + response.status.to_s + '\'', error_model)
        raise mailosaur_error
      end

      response.body
    end

    #
    # Download EML
    #
    # Downloads an EML file representing the specified email. Simply supply the
    # unique identifier for the required email.
    #
    # @param id The identifier of the email to be downloaded.
    #
    # @return [NOT_IMPLEMENTED] operation results.
    #
    def get_email(id)
      response = conn.get 'api/files/email/' + id

      unless response.status == 200
        error_model = JSON.load(response.body)
        mailosaur_error = Mailosaur::MailosaurError.new('Operation returned an invalid status code \'' + response.status.to_s + '\'', error_model)
        raise mailosaur_error
      end

      response.body
    end
  end
end
