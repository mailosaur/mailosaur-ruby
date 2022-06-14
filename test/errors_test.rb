require 'mailosaur'
require 'test/unit'
require 'shoulda/context'

module Mailosaur
  class ErrorsTest < Test::Unit::TestCase
    should 'Unauthorized' do
      client = MailosaurClient.new('invalid_key')
      ex = assert_raise(Mailosaur::MailosaurError) do
        client.servers.list
        pass
      end
      assert_equal('Authentication failed, check your API key.', ex.message)
    end

    should 'Not Found' do
      client = MailosaurClient.new(ENV['MAILOSAUR_API_KEY'])
      ex = assert_raise(Mailosaur::MailosaurError) do
        client.servers.get('not_found')
        pass
      end
      assert_equal('Not found, check input parameters.', ex.message)
    end

    should 'Bad Request' do
      client = MailosaurClient.new(ENV['MAILOSAUR_API_KEY'])
      ex = assert_raise(Mailosaur::MailosaurError) do
        create_options = Mailosaur::Models::ServerCreateOptions.new
        client.servers.create(create_options)
        pass
      end
      assert_equal('(name) Please provide a name for your server\r\n', ex.message)
    end
  end
end
