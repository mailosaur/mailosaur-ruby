require 'mail'
require 'pry'
require 'minitest/autorun'
require 'securerandom'
require './lib/mailosaur'


Mail.defaults do
  delivery_method :smtp,  { address:              'smtp.mandrillapp.com',
                            port:                 587,
                            user_name:            ENV['MANDRILL_NAME'],
                            password:             ENV['MANDRILL_KEY'],
                            authentication:       'plain',
                            enable_starttls_auto: true }
end