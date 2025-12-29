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
  autoload :Devices,                                            'Mailosaur/devices.rb'
  autoload :Previews,                                           'Mailosaur/previews.rb'
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
    autoload :MessageCreateOptions,                               'Mailosaur/models/message_create_options.rb'
    autoload :MessageForwardOptions,                              'Mailosaur/models/message_forward_options.rb'
    autoload :MessageReplyOptions,                                'Mailosaur/models/message_reply_options.rb'
    autoload :Attachment,                                         'Mailosaur/models/attachment.rb'
    autoload :SearchCriteria,                                     'Mailosaur/models/search_criteria.rb'
    autoload :MessageContent,                                     'Mailosaur/models/message_content.rb'
    autoload :Server,                                             'Mailosaur/models/server.rb'
    autoload :Link,                                               'Mailosaur/models/link.rb'
    autoload :Code,                                               'Mailosaur/models/code.rb'
    autoload :ServerListResult,                                   'Mailosaur/models/server_list_result.rb'
    autoload :SpamFilterResults,                                  'Mailosaur/models/spam_filter_results.rb'
    autoload :DeliverabilityReport,                               'Mailosaur/models/deliverability_report.rb'
    autoload :EmailAuthenticationResult,                          'Mailosaur/models/email_authentication_result.rb'
    autoload :BlockListResult,                                    'Mailosaur/models/block_list_result.rb'
    autoload :Content,                                            'Mailosaur/models/content.rb'
    autoload :DnsRecords,                                         'Mailosaur/models/dns_records.rb'
    autoload :SpamAssassinResult,                                 'Mailosaur/models/spam_assassin_result.rb'
    autoload :ServerCreateOptions,                                'Mailosaur/models/server_create_options.rb'
    autoload :UsageAccountLimits,                                 'Mailosaur/models/usage_account_limits.rb'
    autoload :UsageAccountLimit,                                  'Mailosaur/models/usage_account_limit.rb'
    autoload :UsageTransactionListResult,                         'Mailosaur/models/usage_transaction_list_result.rb'
    autoload :UsageTransaction,                                   'Mailosaur/models/usage_transaction.rb'
    autoload :Device,                                             'Mailosaur/models/device.rb'
    autoload :DeviceListResult,                                   'Mailosaur/models/device_list_result.rb'
    autoload :DeviceCreateOptions,                                'Mailosaur/models/device_create_options.rb'
    autoload :OtpResult,                                          'Mailosaur/models/otp_result.rb'
    autoload :Preview,                                            'Mailosaur/models/preview.rb'
    autoload :EmailClient,                                        'Mailosaur/models/email_client.rb'
    autoload :EmailClientListResult,                              'Mailosaur/models/email_client_list_result.rb'
    autoload :PreviewListResult,                                  'Mailosaur/models/preview_list_result.rb'
    autoload :PreviewRequestOptions,                              'Mailosaur/models/preview_request_options.rb'
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

    # @return [Devices] devices
    def devices
      @devices ||= Devices.new(connection, method(:handle_http_error))
    end

    # @return [Previews] previews
    def previews
      @previews ||= Previews.new(connection, method(:handle_http_error))
    end

    private

    def connection
      Faraday.new(@base_url, {
        headers: {
          content_type: 'application/json; charset=utf-8',
          user_agent: "mailosaur-ruby/#{Mailosaur::VERSION}"
        }
      }).tap do |conn|
        case Faraday::VERSION
        when /^0/
          conn.basic_auth @api_key, ''
        when /^1/
          conn.request(:basic_auth, @api_key, '')
        else
          conn.request(:authorization, :basic, @api_key, '')
        end
      end
    end

    def handle_http_error(response)
      message = ''
      case response.status
      when 400
        begin
          json = JSON.parse(response.body)
          json['errors'].each do |err|
            message += format('(%s) %s\r\n', err['field'], err['detail'][0]['description'])
          end
        rescue StandardError
          message = 'Request had one or more invalid parameters.'
        end
        raise Mailosaur::MailosaurError.new(message, 'invalid_request', response.status, response.body)
      when 401
        raise Mailosaur::MailosaurError.new('Authentication failed, check your API key.', 'authentication_error', response.status, response.body)
      when 403
        raise Mailosaur::MailosaurError.new('Insufficient permission to perform that task.', 'permission_error', response.status, response.body)
      when 404
        raise Mailosaur::MailosaurError.new('Not found, check input parameters.', 'invalid_request', response.status, response.body)
      when 410
        raise Mailosaur::MailosaurError.new('Permanently expired or deleted.', 'gone', response.status, response.body)
      else
        raise Mailosaur::MailosaurError.new('An API error occurred, see httpResponse for further information.', 'api_error', response.status, response.body)
      end
    end
  end
end
