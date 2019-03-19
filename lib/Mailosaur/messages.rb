module Mailosaur
  class Messages
    #
    # Creates and initializes a new instance of the Messages class.
    # @param client connection.
    #
    def initialize(conn)
      @conn = conn
    end

    # @return [Connection] the client connection.
    attr_reader :conn

    #
    # Retrieve a message
    #
    # Retrieves the detail for a single email message. Simply supply the unique
    # identifier for the required message.
    #
    # @param id The identifier of the email message to be retrieved.
    #
    # @return [Message] operation results.
    #
    def get(id)
      response = conn.get 'api/messages/' + id
      
      unless response.status == 200
        error_model = JSON.load(response.body)
        mailosaur_error = Mailosaur::MailosaurError.new('Operation returned an invalid status code \'' + response.status.to_s + '\'', error_model)
        raise mailosaur_error
      end

      model = JSON.load(response.body)
      Mailosaur::Models::Message.new(model)
    end

    #
    # Delete a message
    #
    # Permanently deletes a message. This operation cannot be undone. Also deletes
    # any attachments related to the message.
    #
    # @param id The identifier of the message to be deleted.
    #
    def delete(id)
      response = conn.delete 'api/messages/' + id

      unless response.status == 204
        error_model = JSON.load(response.body)
        mailosaur_error = Mailosaur::MailosaurError.new('Operation returned an invalid status code \'' + response.status.to_s + '\'', error_model)
        raise mailosaur_error
      end

      nil
    end

    #
    # List all messages
    #
    # Returns a list of your messages in summary form. The summaries are returned
    # sorted by received date, with the most recently-received messages appearing
    # first.
    #
    # @param server [String] The identifier of the server hosting the messages.
    # @param page [Integer] Used in conjunction with `itemsPerPage` to support
    # pagination.
    # @param items_per_page [Integer] A limit on the number of results to be
    # returned per page. Can be set between 1 and 1000 items, the default is 50.
    #
    # @return [MessageListResult] operation results.
    #
    def list(server, page: nil, items_per_page: nil)
      url = 'api/messages?server=' + server
      url += page ? '&page=' + page : ''
      url += items_per_page ? '&itemsPerPage=' + items_per_page : ''

      response = conn.get url
      
      unless response.status == 200
        error_model = JSON.load(response.body)
        mailosaur_error = Mailosaur::MailosaurError.new('Operation returned an invalid status code \'' + response.status.to_s + '\'', error_model)
        raise mailosaur_error
      end

      model = JSON.load(response.body)
      Mailosaur::Models::MessageListResult.new(model)
    end

    #
    # Delete all messages
    #
    # Permanently deletes all messages held by the specified server. This operation
    # cannot be undone. Also deletes any attachments related to each message.
    #
    # @param server [String] The identifier of the server to be emptied.
    #
    def delete_all(server)
      response = conn.delete 'api/messages?server=' + server

      unless response.status == 204
        error_model = JSON.load(response.body)
        mailosaur_error = Mailosaur::MailosaurError.new('Operation returned an invalid status code \'' + response.status.to_s + '\'', error_model)
        raise mailosaur_error
      end

      nil
    end

    #
    # Search for messages
    #
    # Returns a list of messages matching the specified search criteria, in summary
    # form. The messages are returned sorted by received date, with the most
    # recently-received messages appearing first.
    #
    # @param server [String] The identifier of the server hosting the messages.
    # @param criteria [SearchCriteria] The search criteria to match results
    # against.
    # @param page [Integer] Used in conjunction with `itemsPerPage` to support
    # pagination.
    # @param items_per_page [Integer] A limit on the number of results to be
    # returned per page. Can be set between 1 and 1000 items, the default is 50.
    #
    # @return [MessageListResult] operation results.
    #
    def search(server, criteria, page: nil, items_per_page: nil)
      url = 'api/messages/search?server=' + server
      url += page ? '&page=' + page : ''
      url += items_per_page ? '&itemsPerPage=' + items_per_page : ''
      
      response = conn.post url, criteria.to_json
      
      unless response.status == 200
        error_model = JSON.load(response.body)
        mailosaur_error = Mailosaur::MailosaurError.new('Operation returned an invalid status code \'' + response.status.to_s + '\'', error_model)
        raise mailosaur_error
      end

      model = JSON.load(response.body)
      Mailosaur::Models::MessageListResult.new(model)
    end

    #
    # Wait for a specific message
    #
    # Returns as soon as a message matching the specified search criteria is found.
    # This is the most efficient method of looking up a message.
    #
    # @param server [String] The identifier of the server hosting the message.
    # @param criteria [SearchCriteria] The search criteria to use in order to find
    # a match.
    #
    # @return [Message] operation results.
    #
    def wait_for(server, criteria)
      response = conn.post 'api/messages/await?server=' + server, criteria.to_json
      
      unless response.status == 200
        error_model = JSON.load(response.body)
        mailosaur_error = Mailosaur::MailosaurError.new('Operation returned an invalid status code \'' + response.status.to_s + '\'', error_model)
        raise mailosaur_error
      end

      model = JSON.load(response.body)
      Mailosaur::Models::Message.new(model)
    end
  end
end
