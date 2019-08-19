require 'mailosaur'
require 'test/unit'
require 'shoulda/context'
require './test/mailer'
require 'date'

module Mailosaur
    class FilesTest < Test::Unit::TestCase
        class << self
            def startup
                @@iso_date_string = DateTime.now.strftime('%Y-%m-%d')

                api_key = ENV['MAILOSAUR_API_KEY']
                base_url = ENV['MAILOSAUR_BASE_URL']
                @@server = ENV['MAILOSAUR_SERVER']

                raise ArgumentError, 'Missing necessary environment variables - refer to README.md' if api_key.nil? || @@server.nil?

                @@client = MailosaurClient.new(api_key, base_url)

                @@client.messages.delete_all(@@server)

                host = ENV['MAILOSAUR_SMTP_HOST'] || 'mailosaur.io'
                test_email_address = 'files_test.%s@%s' % [@@server, host]

                Mailer.send_email(@@client, @@server, test_email_address)

                criteria = Mailosaur::Models::SearchCriteria.new()
                criteria.sent_to = test_email_address
                @@email = @@client.messages.get(@@server, criteria)
            end
        end

        context 'get_email' do
            should 'return file content' do
                result = @@client.files.get_email(@@email.id)

                assert_not_nil(result)
                assert_true(result.length > 1)
                assert_true(result.include?(@@email.subject))
            end
        end

        context 'get_attachment' do
            should 'return file content' do
                attachment = @@email.attachments[0]

                result = @@client.files.get_attachment(attachment.id)

                assert_not_nil(result)
                assert_equal(attachment.length, result.length)
            end
        end
    end
end
