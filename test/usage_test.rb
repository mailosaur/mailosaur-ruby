require 'mailosaur'
require 'test/unit'
require 'shoulda/context'

module Mailosaur
    class UsageTest < Test::Unit::TestCase
        setup do
            api_key = ENV['MAILOSAUR_API_KEY']
            base_url = ENV['MAILOSAUR_BASE_URL']

            raise ArgumentError, 'Missing necessary environment variables - refer to README.md' if api_key.nil?

            @client = MailosaurClient.new(api_key, base_url)
        end

        context 'limits' do
            should 'return account limits' do
              result = @client.usage.limits()
              assert_not_nil(result.servers)
              assert_not_nil(result.users)
              assert_not_nil(result.email)
              assert_not_nil(result.sms)

              assert_true(result.servers.limit > 0)
              assert_true(result.users.limit > 0)
              assert_true(result.email.limit > 0)
              assert_true(result.sms.limit > 0)
            end
        end

        context 'transactions' do
            should 'return usage transactions' do
              result = @client.usage.transactions()
              assert_true(result.items.length > 1)
              assert_not_nil(result.items[0].timestamp)
              assert_not_nil(result.items[0].email)
              assert_not_nil(result.items[0].sms)
            end
        end
    end
end
