require 'uri'

module Mailosaur
  # Operations for finding, retrieving, creating, forwarding, replying to, and deleting the
  # email and SMS messages received by your Mailosaur servers. Accessed via +client.messages+.
  class Messages
    #
    # Creates and initializes a new instance of the Messages class.
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
    # Waits for a message to be found. Returns as soon as a message matching the specified
    # search criteria is found. This is the most efficient method of looking up a message,
    # therefore we recommend using it wherever possible.
    #
    # @param server [String] The unique identifier of the containing server.
    # @param criteria [Mailosaur::Models::SearchCriteria] The criteria with which to find
    #   messages during a search.
    # @param timeout [Integer] Specify how long to wait for a matching result
    #   (in milliseconds).
    # @param received_after [DateTime] Limits results to only messages received
    #   after this date/time.
    # @param dir [String] Optionally limits results based on the direction (+Sent+
    #   or +Received+), with the default being +Received+.
    #
    # @return [Mailosaur::Models::Message] The first message matching the criteria.
    #
    # @raise [Mailosaur::MailosaurError] With error code +no_messages_found+ if no matching
    #   message exists, or +search_timeout+ if no matching message arrives before the timeout elapses.
    #
    def get(server, criteria, timeout: 10_000, received_after: DateTime.now - (1.0 / 24), dir: nil)
      # Defaults timeout to 10s, receivedAfter to 1h
      raise Mailosaur::MailosaurError.new('Must provide a valid Server ID.', 'invalid_request') if server.length != 8

      result = search(server, criteria, page: 0, items_per_page: 1, timeout: timeout, received_after: received_after, dir: dir)
      get_by_id(result.items[0].id)
    end

    #
    # Retrieves the detail for a single message. Must be used in conjunction with either
    # {#list} or {#search} in order to get the unique identifier for the required message.
    #
    # @param id [String] The unique identifier of the message to be retrieved.
    #
    # @return [Mailosaur::Models::Message] The full message.
    #
    def get_by_id(id)
      response = conn.get "api/messages/#{id}"
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::Message.new(model)
    end

    #
    # Permanently deletes a message. Also deletes any attachments related to the message.
    # This operation cannot be undone.
    #
    # @param id [String] The identifier for the message.
    #
    # @return [nil] Once the message has been deleted.
    #
    def delete(id)
      response = conn.delete "api/messages/#{id}"
      @handle_http_error.call(response) unless response.status == 204
      nil
    end

    #
    # Returns a list of your messages in summary form. The summaries are returned
    # sorted by received date, with the most recently-received messages appearing
    # first.
    #
    # @param server [String] The unique identifier of the required server.
    # @param page [Integer] Used in conjunction with +items_per_page+ to support
    #   pagination.
    # @param items_per_page [Integer] A limit on the number of results to be
    #   returned per page. Can be set between 1 and 1000 items, the default is 50.
    # @param received_after [DateTime] Limits results to only messages received
    #   after this date/time.
    # @param dir [String] Optionally limits results based on the direction (+Sent+
    #   or +Received+), with the default being +Received+.
    #
    # @return [Mailosaur::Models::MessageListResult] The message summaries.
    #
    def list(server, page: nil, items_per_page: nil, received_after: nil, dir: nil)
      url = "api/messages?server=#{server}"
      url += page ? "&page=#{page}" : ''
      url += items_per_page ? "&itemsPerPage=#{items_per_page}" : ''
      url += received_after ? "&receivedAfter=#{CGI.escape(received_after.iso8601)}" : ''
      url += dir ? "&dir=#{dir}" : ''

      response = conn.get url

      @handle_http_error.call(response) unless response.status == 200

      model = JSON.parse(response.body)
      Mailosaur::Models::MessageListResult.new(model)
    end

    #
    # Permanently delete all messages within a server. This operation cannot be undone.
    #
    # @param server [String] The unique identifier of the server.
    #
    # @return [nil] Once all messages within the server have been deleted.
    #
    def delete_all(server)
      response = conn.delete "api/messages?server=#{server}"
      @handle_http_error.call(response) unless response.status == 204
      nil
    end

    #
    # Returns a list of messages matching the specified search criteria, in summary
    # form. The messages are returned sorted by received date, with the most
    # recently-received messages appearing first.
    #
    # @param server [String] The unique identifier of the server to search.
    # @param criteria [Mailosaur::Models::SearchCriteria] The criteria with which to find
    #   messages during a search.
    # @param page [Integer] Used in conjunction with +items_per_page+ to support
    #   pagination.
    # @param items_per_page [Integer] A limit on the number of results to be
    #   returned per page. Can be set between 1 and 1000 items, the default is 50.
    # @param timeout [Integer] Specify how long to wait for a matching result
    #   (in milliseconds).
    # @param received_after [DateTime] Limits results to only messages received
    #   after this date/time.
    # @param error_on_timeout [Boolean] When set to false, an error will not be
    #   raised if the timeout is reached (default: true).
    # @param dir [String] Optionally limits results based on the direction (+Sent+
    #   or +Received+), with the default being +Received+.
    #
    # @return [Mailosaur::Models::MessageListResult] The matching message summaries.
    #
    # @raise [Mailosaur::MailosaurError] With error code +search_timeout+ if no matching message
    #   is found before the timeout elapses, unless +error_on_timeout+ is set to false.
    #
    def search(server, criteria, page: nil, items_per_page: nil, timeout: nil, received_after: nil, error_on_timeout: true, dir: nil)
      url = "api/messages/search?server=#{server}"
      url += page ? "&page=#{page}" : ''
      url += items_per_page ? "&itemsPerPage=#{items_per_page}" : ''
      url += received_after ? "&receivedAfter=#{CGI.escape(received_after.iso8601)}" : ''
      url += dir ? "&dir=#{dir}" : ''

      poll_count = 0
      start_time = Time.now.to_f

      loop do
        response = conn.post url, criteria.to_json

        @handle_http_error.call(response) unless response.status == 200

        model = JSON.parse(response.body)
        return Mailosaur::Models::MessageListResult.new(model) if timeout.to_i.zero? || !model['items'].empty?

        delay_pattern = (response.headers['x-ms-delay'] || '1000').split(',').map(&:to_i)

        delay = poll_count >= delay_pattern.length ? delay_pattern[delay_pattern.length - 1] : delay_pattern[poll_count]

        poll_count += 1

        ## Stop if timeout will be exceeded
        if ((1000 * (Time.now.to_f - start_time).to_i) + delay) > timeout
          return Mailosaur::Models::MessageListResult.new(model) unless error_on_timeout

          msg = format('No matching messages found in time. By default, only messages received in the last hour are checked (use receivedAfter to override this). The search criteria used for this query was [%s] which timed out after %sms',
                       criteria.to_json, timeout)
          raise Mailosaur::MailosaurError.new(msg, 'search_timeout')
        end

        sleep(delay / 1000)
      end
    end

    #
    # Creates a new message that can be sent to a verified email address. This is
    # useful in scenarios where you want an email to trigger a workflow in your
    # product.
    #
    # @param server [String] The unique identifier of the required server.
    # @param message_create_options [Mailosaur::Models::MessageCreateOptions] Options to use
    #   when creating a new message.
    #
    # @return [Mailosaur::Models::Message] The newly-created message.
    #
    def create(server, message_create_options)
      response = conn.post "api/messages?server=#{server}", message_create_options.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::Message.new(model)
    end

    #
    # Forwards the specified message to a verified email address. This is useful for
    # simulating a user forwarding one of your email messages.
    #
    # @param id [String] The unique identifier of the message to be forwarded.
    # @param message_forward_options [Mailosaur::Models::MessageForwardOptions] Options to use
    #   when forwarding a message.
    #
    # @return [Mailosaur::Models::Message] The forwarded message.
    #
    def forward(id, message_forward_options)
      response = conn.post "api/messages/#{id}/forward", message_forward_options.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::Message.new(model)
    end

    #
    # Sends a reply to the specified message. This is useful for when simulating a user
    # replying to one of your email or SMS messages.
    #
    # @param id [String] The unique identifier of the message to be replied to.
    # @param message_reply_options [Mailosaur::Models::MessageReplyOptions] Options to use
    #   when replying to a message.
    #
    # @return [Mailosaur::Models::Message] The reply message.
    #
    def reply(id, message_reply_options)
      response = conn.post "api/messages/#{id}/reply", message_reply_options.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::Message.new(model)
    end

    #
    # Generates screenshots of an email rendered in the specified email clients.
    #
    # @param id [String] The identifier of the email to preview.
    # @param options [Mailosaur::Models::PreviewRequestOptions] The options with which to
    #   generate previews.
    #
    # @return [Mailosaur::Models::PreviewListResult] The generated previews.
    #
    def generate_previews(id, options)
      response = conn.post "api/messages/#{id}/screenshots", options.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::PreviewListResult.new(model)
    end
  end
end
