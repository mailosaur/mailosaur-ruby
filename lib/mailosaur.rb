require 'date'
require 'json'
require 'base64'
require 'erb'
require 'securerandom'
require 'time'
require 'timeliness'
require 'faraday'
require 'faraday-cookie_jar'
require 'concurrent'
require 'ms_rest'
require 'Mailosaur/module_definition'

module Mailosaur
  autoload :Analysis,                                           'Mailosaur/analysis.rb'
  autoload :Files,                                              'Mailosaur/files.rb'
  autoload :Messages,                                           'Mailosaur/messages.rb'
  autoload :Servers,                                            'Mailosaur/servers.rb'
  autoload :MailosaurBaseClient,                                'Mailosaur/mailosaur_base_client.rb'
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
  end

  class MailosaurClient < MailosaurBaseClient
    def initialize(api_key, base_url = 'https://mailosaur.com/')
      credentials = MsRest::BasicAuthenticationCredentials.new(api_key, '')
      super(credentials, base_url, nil)
    end
  end

  # Monkey patch generate_email_address method
  class Servers
    def generate_email_address(server)
      host = ENV['MAILOSAUR_SMTP_HOST'] || 'mailosaur.io'
      '%s.%s@%s' % [SecureRandom.hex(3), server, host]
    end
  end
end
