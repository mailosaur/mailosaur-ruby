require 'mailosaur'
require 'test/unit'
require 'shoulda/context'
require './test/mailer'
require 'date'

module Mailosaur
    class EmailsTest < Test::Unit::TestCase
        class << self
            def startup
                @@iso_date_string = DateTime.now.strftime('%Y-%m-%d')

                api_key = ENV['MAILOSAUR_API_KEY']
                base_url = ENV['MAILOSAUR_BASE_URL']
                @@server = ENV['MAILOSAUR_SERVER']

                raise ArgumentError, 'Missing necessary environment variables - refer to README.md' if api_key.nil? || @@server.nil?

                @@client = MailosaurClient.new(api_key, base_url)

                @@client.messages.delete_all(@@server)

                Mailer.send_emails(@@client, @@server, 5)

                @@emails = @@client.messages.list(@@server).items
            end
        end

        context 'list' do
            should 'return a list of emails' do
                assert_equal(5, @@emails.length)

                @@emails.each do |email|
                    validate_email_summary(email)
                end
            end

            should 'filter on received after date' do
                past_date = DateTime.now - (10 / 1440.0)
                past_emails = @@client.messages.list(@@server, received_after: past_date).items
                assert_true(!past_emails.empty?)

                future_emails = @@client.messages.list(@@server, received_after: DateTime.now()).items
                assert_equal(0, future_emails.length)
            end
        end

        context 'get' do
            should 'return a match once found' do
                host = ENV['MAILOSAUR_SMTP_HOST'] || 'mailosaur.io'
                test_email_address = 'wait_for_test.%s@%s' % [@@server, host]

                Mailer.send_email(@@client, @@server, test_email_address)

                criteria = Mailosaur::Models::SearchCriteria.new()
                criteria.sent_to = test_email_address
                email = @@client.messages.get(@@server, criteria)
                validate_email(email)
            end
        end

        context 'get_by_id' do
            should 'return a single email' do
                email_to_retrieve = @@emails[0]
                email = @@client.messages.get_by_id(email_to_retrieve.id)
                validate_email(email)
                validate_headers(email)
            end

            should 'throw an error if email not found' do
                assert_raise(Mailosaur::MailosaurError) do
                    @@client.messages.get_by_id('efe907e9-74ed-4113-a3e0-a3d41d914765')
                end
            end
        end

        context 'search' do
            should 'throw an error if no criteria' do
                assert_raise(Mailosaur::MailosaurError) do
                    criteria = Mailosaur::Models::SearchCriteria.new()
                    @@client.messages.search(@@server, criteria)
                end
            end

            context 'by sent_to' do
                should 'return matching results' do
                    target_email = @@emails[1]
                    criteria = Mailosaur::Models::SearchCriteria.new()
                    criteria.sent_to = target_email.to[0].email
                    results = @@client.messages.search(@@server, criteria).items
                    assert_equal(1, results.length)
                    assert_equal(target_email.to[0].email, results[0].to[0].email)
                    assert_equal(target_email.subject, results[0].subject)
                end

                should 'throw an error on invalid email address' do
                    criteria = Mailosaur::Models::SearchCriteria.new()
                    criteria.sent_to = '.not_an_email_address'

                    assert_raise(Mailosaur::MailosaurError) do
                        @@client.messages.search(@@server, criteria)
                    end
                end
            end

            context 'by body' do
                should 'return matching results' do
                    target_email = @@emails[1]
                    unique_string = target_email.subject[0, 10]
                    criteria = Mailosaur::Models::SearchCriteria.new()
                    criteria.body = '%s html' % [unique_string]
                    results = @@client.messages.search(@@server, criteria).items
                    assert_equal(1, results.length)
                    assert_equal(target_email.to[0].email, results[0].to[0].email)
                    assert_equal(target_email.subject, results[0].subject)
                end
            end

            context 'by subject' do
                should 'return matching results' do
                    target_email = @@emails[1]
                    unique_string = target_email.subject[0, 10]
                    criteria = Mailosaur::Models::SearchCriteria.new()
                    criteria.subject = unique_string
                    results = @@client.messages.search(@@server, criteria).items
                    assert_equal(1, results.length)
                    assert_equal(target_email.to[0].email, results[0].to[0].email)
                    assert_equal(target_email.subject, results[0].subject)
                end
            end
        end

        context 'spam_analysis' do
            should 'perform a spam analysis on an email' do
                target_id = @@emails[0].id
                result = @@client.analysis.spam(target_id)

                result.spam_filter_results.spam_assassin.each do |rule|
                    assert_instance_of(Float, rule.score)
                    assert_not_nil(rule.rule)
                    assert_not_nil(rule.description)
                end
            end
        end

        context 'delete' do
            should 'delete an email' do
                target_id = @@emails[4].id

                @@client.messages.delete(target_id)

                # Attempting to delete again should fail
                assert_raise(Mailosaur::MailosaurError) do
                    @@client.messages.delete(target_id)
                end
            end
        end

      private

        def validate_email(email)
          validate_metadata(email)
          validate_attachments(email)
          validate_html(email)
          validate_text(email)
        end

          def validate_email_summary(email)
              validate_metadata(email)
              assert_not_nil(email.summary)
              assert_equal(2, email.attachments)
          end

          def validate_html(email)
              # Html.Body
              assert_true(email.html.body.start_with?('<div dir="ltr">'))

              # Html.Links
              assert_equal(3, email.html.links.length)
              assert_equal('https://mailosaur.com/', email.html.links[0].href)
              assert_equal('mailosaur', email.html.links[0].text)
              assert_equal('https://mailosaur.com/', email.html.links[1].href)
              assert_nil(email.html.links[1].text)
              assert_equal('http://invalid/', email.html.links[2].href)
              assert_equal('invalid', email.html.links[2].text)

              # Html.Images
              assert_true(email.html.images[1].src.start_with?('cid:'))
              assert_equal('Inline image 1', email.html.images[1].alt)
          end

          def validate_text(email)
              # Text.Body
              assert_true(email.text.body.start_with?('this is a test'))

              # Text.Links
              assert_equal(2, email.text.links.length)
              assert_equal('https://mailosaur.com/', email.text.links[0].href)
              assert_equal(email.text.links[0].href, email.text.links[0].text)
              assert_equal('https://mailosaur.com/', email.text.links[1].href)
              assert_equal(email.text.links[1].href, email.text.links[1].text)
          end

          def validate_headers(email)
            #   expected_from_header = "%s <%s>" % [expected.from[0].name, expected.from[0].email]
            #   expected_to_header = "%s <%s>" % [expected.to[0].name, expected.to[0].email]

            # Fallback casing for headers is used, as header casing is determined by sending server
            #   assert_equal(expected_from_header, actual.headers['from'] || actual.headers['From'])
            #   assert_equal(expected_to_header, actual.headers['to'] || actual.headers['To'])
            #   assert_equal(expected.subject, actual.headers['subject'] || actual.headers['Subject'])
          end

          def validate_metadata(email)
              assert_equal(1, email.from.length)
              assert_equal(1, email.to.length)
              assert_not_nil(email.from[0].email)
              assert_not_nil(email.from[0].name)
              assert_not_nil(email.to[0].email)
              assert_not_nil(email.to[0].name)
              assert_not_nil(email.subject)
              assert_not_nil(email.server)

              assert_equal(@@iso_date_string, email.received.strftime('%Y-%m-%d'))
          end

          def validate_attachments(email)
              assert_equal(2, email.attachments.length)

              file1 = email.attachments[0]
              assert_not_nil(file1.id)
              assert_not_nil(file1.url)
              assert_equal(82_138, file1.length)
              assert_equal('cat.png', file1.file_name)
              assert_equal('image/png', file1.content_type)

              file2 = email.attachments[1]
              assert_not_nil(file2.id)
              assert_not_nil(file2.url)
              assert_equal(212_080, file2.length)
              assert_equal('dog.png', file2.file_name)
              assert_equal('image/png', file2.content_type)
          end
    end
end
