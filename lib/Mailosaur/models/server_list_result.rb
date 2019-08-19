module Mailosaur
  module Models
    class ServerListResult < BaseModel
      def initialize(data = {})
        @items = []
        (data['items'] || []).each do |i| @items << Mailosaur::Models::Server.new(i) end
      end

      # @return [Array<Server>] The individual servers forming the result.
      # Servers are returned sorted by creation date, with the most
      # recently-created server appearing first.
      attr_accessor :items
    end
  end
end
