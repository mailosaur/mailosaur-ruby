module Mailosaur
  class Devices
    #
    # Creates and initializes a new instance of the Devices class.
    # @param client connection.
    #
    def initialize(conn, handle_http_error)
      @conn = conn
      @handle_http_error = handle_http_error
    end

    # @return [Connection] the client connection.
    attr_reader :conn

    #
    # List all devices
    #
    # Returns a list of your virtual security devices.
    #
    # @return [DeviceListResult] operation results.
    #
    def list
      response = conn.get 'api/devices'
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::DeviceListResult.new(model)
    end

    #
    # Create a device
    #
    # Creates a new virtual security device and returns it.
    #
    # @param device_create_options [DeviceCreateOptions]
    #
    # @return [Device] operation results.
    #
    def create(device_create_options)
      response = conn.post 'api/devices', device_create_options.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::Device.new(model)
    end

    #
    # Retrieve OTP
    #
    # Retrieves the current one-time password for a saved device, or given base32-encoded shared secret.
    #
    # @param query [String] Either the unique identifier of the device, or a base32-encoded shared secret.
    #
    # @return [OtpResult] operation results.
    #
    def otp(query)
      if query.include? '-'
        response = conn.get "api/devices/#{query}/otp"
        @handle_http_error.call(response) unless response.status == 200
        model = JSON.parse(response.body)
        return Mailosaur::Models::OtpResult.new(model)
      end

      options = Mailosaur::Models::DeviceCreateOptions.new
      options.shared_secret = query
      response = conn.post 'api/devices/otp', options.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::OtpResult.new(model)
    end

    #
    # Delete a device
    #
    # Permanently deletes a device. This operation cannot be undone.
    #
    # @param id [String] The identifier of the device to be deleted.
    #
    def delete(id)
      response = conn.delete "api/devices/#{id}"
      @handle_http_error.call(response) unless response.status == 204
      nil
    end
  end
end
