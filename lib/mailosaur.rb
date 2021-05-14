require 'date'
require 'json'
require 'base64'
require 'erb'
require 'securerandom'
require 'time'
require 'faraday'
require 'Mailosaur/module_definition'
require 'Mailosaur/version'

module Mailosaur
  autoload :Analysis,                                           'Mailosaur/analysis.rb'
  autoload :Files,                                              'Mailosaur/files.rb'
  autoload :Messages,                                           'Mailosaur/messages.rb'
  autoload :Servers,                                            'Mailosaur/servers.rb'
  autoload :Usage,                                              'Mailosaur/usage.rb'
  autoload :MailosaurError,                                     'Mailosaur/mailosaur_error.rb'

  module Models
    autoload :MessageHeader,                                      'Mailosaur/models/message_header.rb'
    autoload :SpamAssassinRule,                                   'Mailosaur/models/spam_assassin_rule.rb'
    autoload :Metadata,                                           'Mailosaur/models/metadata.rb'
    autoload :SpamAnalysisResult,                                 'Mailosaur/models/spam_analysis_result.rb'
    autoload :Message,                                            'Mailosaur/models/message.rb'
    autoload :MessageAddress,                                     'Mailosaur/models/message_address.rb'
    autoload :MessageSummary,                                     'Mailosaur/models/message_summary.rb'
    autoload :Image,                                              'Mailosaur/models/image.rb'
    autoload :MessageListResult,                                  'Mailosaur/models/message_list_result.rb'
    autoload :Attachment,                                         'Mailosaur/models/attachment.rb'
    autoload :SearchCriteria,                                     'Mailosaur/models/search_criteria.rb'
    autoload :MessageContent,                                     'Mailosaur/models/message_content.rb'
    autoload :Server,                                             'Mailosaur/models/server.rb'
    autoload :Link,                                               'Mailosaur/models/link.rb'
    autoload :ServerListResult,                                   'Mailosaur/models/server_list_result.rb'
    autoload :SpamFilterResults,                                  'Mailosaur/models/spam_filter_results.rb'
    autoload :ServerCreateOptions,                                'Mailosaur/models/server_create_options.rb'
    autoload :UsageAccountLimits,                                 'Mailosaur/models/usage_account_limits.rb'
    autoload :UsageAccountLimit,                                  'Mailosaur/models/usage_account_limit.rb'
    autoload :UsageTransactionListResult,                         'Mailosaur/models/usage_transaction_list_result.rb'
    autoload :UsageTransaction,                                   'Mailosaur/models/usage_transaction.rb'
    autoload :BaseModel,                                          'Mailosaur/models/base_model.rb'
  end

  class MailosaurClient
    #
    # Creates initializes a new instance of the MailosaurClient class.
    # @param api_key [String] your Mailosaur API key.
    # @param base_url [String] the base URI of the service.
    #
    def initialize(api_key, base_url = 'https://mailosaur.com/')
      @api_key = api_key
      @base_url = base_url
    end

    # @return [Analysis] analysis
    def analysis
      @analysis ||= Analysis.new(connection, method(:handle_http_error))
    end

    # @return [Files] files
    def files
      @files ||= Files.new(connection, method(:handle_http_error))
    end

    # @return [Messages] messages
    def messages
      @messages ||= Messages.new(connection, method(:handle_http_error))
    end

    # @return [Servers] servers
    def servers
      @servers ||= Servers.new(connection, method(:handle_http_error))
    end

    # @return [Usage] usage
    def usage
      @usage ||= Usage.new(connection, method(:handle_http_error))
    end

    private

    def connection
      Faraday.new(@base_url, {
        headers: {
          content_type: 'application/json; charset=utf-8',
          user_agent: 'mailosaur-ruby/' + Mailosaur::VERSION
        }
      }).tap { |conn| conn.basic_auth(@api_key, '') }
    end

    def handle_http_error(response)
      case response.status
      when 400
        raise Mailosaur::MailosaurError.new('Request had one or more invalid parameters.', 'invalid_request', response.status, response.body)
      when 401
        raise Mailosaur::MailosaurError.new('Authentication failed, check your API key.', 'authentication_error', response.status, response.body)
      when 403
        raise Mailosaur::MailosaurError.new('Insufficient permission to perform that task.', 'permission_error', response.status, response.body)
      when 404
        raise Mailosaur::MailosaurError.new('Request did not find any matching resources.', 'invalid_request', response.status, response.body)
      else
        raise Mailosaur::MailosaurError.new('An API error occurred, see httpResponse for further information.', 'api_error', response.status, response.body)
      end
    end
  end
end
