require 'mailosaur'
require 'test/unit'
require 'shoulda/context'
require './test/mailer'
require 'date'

module Mailosaur
  class PreviewsTest < Test::Unit::TestCase
    class << self
      def startup
        api_key = ENV['MAILOSAUR_API_KEY']
        base_url = ENV['MAILOSAUR_BASE_URL']
        @@server = ENV['MAILOSAUR_PREVIEWS_SERVER']

        raise ArgumentError, 'Missing necessary environment variables - refer to README.md' if api_key.nil?

        @@client = MailosaurClient.new(api_key, base_url)
      end
    end

    context 'list email clients' do
      should 'return a list of email clients' do
        result = @@client.previews.list_email_clients
        assert_true(result.items.length > 1)
      end
    end

    context 'generate previews' do
      should 'reply with attachment' do
        omit_if(@@server.nil?)

        random_string = (0...10).map { rand(65..90).chr }.join
        host = ENV['MAILOSAUR_SMTP_HOST'] || 'mailosaur.net'
        test_email_address = format('%s@%s.%s', random_string, @@server, host)

        Mailer.send_email(@@client, @@server, test_email_address)

        criteria = Mailosaur::Models::SearchCriteria.new
        criteria.sent_to = test_email_address
        email = @@client.messages.get(@@server, criteria)

        request = Mailosaur::Models::PreviewRequest.new('OL2021')
        options = Mailosaur::Models::PreviewRequestOptions.new([request])

        result = @@client.messages.generate_previews(email.id, options)

        assert_true(result.items.length > 0)

        # Ensure we can download one of the generated preview
        file = @@client.files.get_preview(result.items[0].id)
        assert_not_nil(file)
      end
    end
  end
end
