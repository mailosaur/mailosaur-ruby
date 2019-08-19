require 'mailosaur'
require 'test/unit'
require 'shoulda/context'

module Mailosaur
    class ServersTest < Test::Unit::TestCase
        setup do
            api_key = ENV['MAILOSAUR_API_KEY']
            base_url = ENV['MAILOSAUR_BASE_URL']

            raise ArgumentError, 'Missing necessary environment variables - refer to README.md' if api_key.nil?

            @client = MailosaurClient.new(api_key, base_url)
        end

        context 'list' do
            should 'return a list of servers' do
              result = @client.servers.list()
              assert_true(result.items.length > 1)
            end
        end

        context 'get' do
            should 'throw an error if server not found' do
                assert_raise(Mailosaur::MailosaurError) do
                    @client.servers.get('efe907e9-74ed-4113-a3e0-a3d41d914765')
                end
            end
        end

        should 'perform CRUD operations' do
            server_name = 'My test'

            # Create a new server
            create_options = Mailosaur::Models::ServerCreateOptions.new()
            create_options.name = server_name
            created_server = @client.servers.create(create_options)
            assert_not_nil(created_server.id)
            assert_equal(server_name, created_server.name)
            assert_not_nil(created_server.password)
            assert_instance_of(Array, created_server.users)
            assert_instance_of(Fixnum, created_server.messages)
            assert_instance_of(Array, created_server.forwarding_rules)

            # Retrieve a server and confirm it has expected content
            retrieved_server = @client.servers.get(created_server.id)
            assert_equal(created_server.id, retrieved_server.id)
            assert_equal(created_server.name, retrieved_server.name)
            assert_not_nil(retrieved_server.password)
            assert_instance_of(Array, retrieved_server.users)
            assert_instance_of(Fixnum, retrieved_server.messages)
            assert_instance_of(Array, retrieved_server.forwarding_rules)

            # Update a server and confirm it has changed
            retrieved_server.name += ' EDITED'
            updated_server = @client.servers.update(retrieved_server.id, retrieved_server)
            assert_equal(retrieved_server.id, updated_server.id)
            assert_equal(retrieved_server.name, updated_server.name)
            assert_equal(retrieved_server.password, updated_server.password)
            assert_equal(retrieved_server.users, updated_server.users)
            assert_equal(retrieved_server.messages, updated_server.messages)
            assert_equal(retrieved_server.forwarding_rules, updated_server.forwarding_rules)

            @client.servers.delete(retrieved_server.id)

            # Attempting to delete again should fail
            assert_raise(Mailosaur::MailosaurError) do
              @client.servers.delete(retrieved_server.id)
              pass
            end
        end

        should 'fail to create a server with no name' do
            ex = assert_raise(Mailosaur::MailosaurError) do
              create_options = Mailosaur::Models::ServerCreateOptions.new()
              @client.servers.create(create_options)
              pass
            end

            assert_equal("Operation returned an invalid status code '400'", ex.message)
            assert_equal('ValidationError', ex.type)
            assert_equal(1, ex.messages.length)
            assert_not_nil(ex.messages['name'])
        end
    end
end
