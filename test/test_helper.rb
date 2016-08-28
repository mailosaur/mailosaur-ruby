require 'mail'
require 'pry'
require 'minitest/autorun'
require 'securerandom'
require './lib/mailosaur'


Mail.defaults do
  delivery_method :smtp,  { address:              ENV['MAILOSAUR_SMTP_HOST'] || 'mailosaur.io',
                            port:                 ENV['MAILOSAUR_SMTP_PORT'] || 25,
                            #user_name:            ENV['MAILOSAUR_MAILBOX_ID'],
                            #password:             ENV['MAILOSAUR_MAILBOX_PASSWORD'],
                            #authentication:       'plain',
                            enable_starttls_auto: false }
end