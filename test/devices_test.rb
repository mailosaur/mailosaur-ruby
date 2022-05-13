require 'mailosaur'
require 'test/unit'
require 'shoulda/context'

module Mailosaur
  class DevicesTest < Test::Unit::TestCase
    setup do
      api_key = ENV['MAILOSAUR_API_KEY']
      base_url = ENV['MAILOSAUR_BASE_URL']

      raise ArgumentError, 'Missing necessary environment variables - refer to README.md' if api_key.nil?

      @client = MailosaurClient.new(api_key, base_url)
    end

    should 'perform CRUD operations' do
      device_name = 'My test'
      shared_secret = 'ONSWG4TFOQYTEMY='

      # Create a new device
      create_options = Mailosaur::Models::DeviceCreateOptions.new
      create_options.name = device_name
      create_options.shared_secret = shared_secret

      created_device = @client.devices.create(create_options)
      assert_not_nil(created_device.id)
      assert_equal(device_name, created_device.name)

      # Retrieve an otp via device ID
      otp_result = @client.devices.otp(created_device.id)
      assert_equal(6, otp_result.code.length)

      before = @client.devices.list
      assert_true(before.items.any? { |x| x.id == created_device.id })

      @client.devices.delete(created_device.id)

      after = @client.devices.list
      assert_false(after.items.any? { |x| x.id == created_device.id })
    end

    should 'return OTP given via a shared secret' do
      shared_secret = 'ONSWG4TFOQYTEMY='

      otp_result = @client.devices.otp(shared_secret)
      assert_equal(6, otp_result.code.length)
    end
  end
end
