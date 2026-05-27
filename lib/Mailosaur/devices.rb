module Mailosaur
  # Operations for managing virtual security devices and retrieving their current one-time
  # passwords (OTPs), used to automate testing of app-based multi-factor authentication.
  # Accessed via +client.devices+.
  class Devices
    #
    # Creates and initializes a new instance of the Devices class.
    # @param conn [Faraday::Connection] The client connection.
    # @param handle_http_error [Method] Callback used to convert HTTP error responses into errors.
    #
    def initialize(conn, handle_http_error)
      @conn = conn
      @handle_http_error = handle_http_error
    end

    # @return [Connection] the client connection.
    attr_reader :conn

    #
    # Returns a list of your virtual security devices.
    #
    # @return [Mailosaur::Models::DeviceListResult] Your devices.
    #
    def list
      response = conn.get 'api/devices'
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::DeviceListResult.new(model)
    end

    #
    # Creates a new virtual security device.
    #
    # @param device_create_options [Mailosaur::Models::DeviceCreateOptions] Options used to
    #   create a new Mailosaur virtual security device.
    #
    # @return [Mailosaur::Models::Device] The newly-created device.
    #
    def create(device_create_options)
      response = conn.post 'api/devices', device_create_options.to_json
      @handle_http_error.call(response) unless response.status == 200
      model = JSON.parse(response.body)
      Mailosaur::Models::Device.new(model)
    end

    #
    # Retrieves the current one-time password for a saved device, or given base32-encoded
    # shared secret.
    #
    # @param query [String] Either the unique identifier of the device, or a base32-encoded
    #   shared secret.
    #
    # @return [Mailosaur::Models::OtpResult] The current one-time password.
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
    # Permanently delete a virtual security device. This operation cannot be undone.
    #
    # @param id [String] The unique identifier of the device.
    #
    # @return [nil] Once the device has been deleted.
    #
    def delete(id)
      response = conn.delete "api/devices/#{id}"
      @handle_http_error.call(response) unless response.status == 204
      nil
    end
  end
end
