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

              assert_true(result.servers.current >= 0 && result.servers.current <= result.servers.limit)
              assert_true(result.users.current >= 0 && result.users.current <= result.users.limit)
              assert_true(result.email.current >= 0 && result.email.current <= result.email.limit)
              assert_true(result.sms.current >= 0 && result.sms.current <= result.sms.limit)
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
