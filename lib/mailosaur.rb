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
    autoload :ForwardingRule,                                     'Mailosaur/models/forwarding_rule.rb'
    autoload :MessageContent,                                     'Mailosaur/models/message_content.rb'
    autoload :Server,                                             'Mailosaur/models/server.rb'
    autoload :Link,                                               'Mailosaur/models/link.rb'
    autoload :ServerListResult,                                   'Mailosaur/models/server_list_result.rb'
    autoload :SpamFilterResults,                                  'Mailosaur/models/spam_filter_results.rb'
    autoload :ServerCreateOptions,                                'Mailosaur/models/server_create_options.rb'
    autoload :BaseModel,                                          'Mailosaur/models/base_model.rb'
  end

  class MailosaurClient
    # @return [Analysis] analysis
    attr_reader :analysis

    # @return [Files] files
    attr_reader :files

    # @return [Messages] messages
    attr_reader :messages

    # @return [Servers] servers
    attr_reader :servers

    #
    # Creates initializes a new instance of the MailosaurClient class.
    # @param api_key [String] your Mailosaur API key.
    # @param base_url [String] the base URI of the service.
    #
    def initialize(api_key, base_url)
      conn = Faraday.new(base_url || 'https://mailosaur.com/', {
        :headers => {
          :content_type => 'application/json; charset=utf-8',
          :user_agent => 'mailosaur-ruby/' + Mailosaur::VERSION
        }
      })

      conn.basic_auth(api_key, '')

      @analysis = Analysis.new(conn)
      @files = Files.new(conn)
      @messages = Messages.new(conn)
      @servers = Servers.new(conn)
    end
  end
end
