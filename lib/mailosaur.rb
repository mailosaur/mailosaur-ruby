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
    autoload :Message,                                            'Mailosaur/models/message.rb'
    autoload :Link,                                               'Mailosaur/models/link.rb'
    autoload :MessageSummary,                                     'Mailosaur/models/message_summary.rb'
    autoload :MessageContent,                                     'Mailosaur/models/message_content.rb'
    autoload :MessageListResult,                                  'Mailosaur/models/message_list_result.rb'
    autoload :SpamCheckResult,                                    'Mailosaur/models/spam_check_result.rb'
    autoload :SearchCriteria,                                     'Mailosaur/models/search_criteria.rb'
    autoload :Image,                                              'Mailosaur/models/image.rb'
    autoload :ForwardingRule,                                     'Mailosaur/models/forwarding_rule.rb'
    autoload :MessageAddress,                                     'Mailosaur/models/message_address.rb'
    autoload :Server,                                             'Mailosaur/models/server.rb'
    autoload :Attachment,                                         'Mailosaur/models/attachment.rb'
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
