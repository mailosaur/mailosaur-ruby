module Mailosaur
  module Models
    class ServerListResult < BaseModel
      def initialize(data = {})
        @items = []
        (data['items'] || []).each do |i| @items << Mailosaur::Models::Server.new(i) end
      end

      # @return [Array<Server>] The individual inboxes (servers) forming the result.
      # Inboxes (servers) are returned sorted by creation date, with the most
      # recently-created inbox (server) appearing first.
      attr_accessor :items
    end
  end
end
