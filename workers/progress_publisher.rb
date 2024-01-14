# frozen_string_literal: true

require 'http'

module PetAdoption
  module Background
    # Publishes progress as percent to Faye endpoint
    class ProgressPublisher
      def initialize(config, finder_id)
        @config = config
        @finder_id = finder_id
      end

      def publish(message)
        print "Progress: #{message} "
        print "[post: #{@config.API_HOST}/faye] "
        response = HTTP.headers(content_type: 'application/json')
          .post(
            "#{@config.API_HOST}/faye",
            body: message_body(message)
          )
        puts "(#{response.status})"
      rescue HTTP::ConnectionError
        puts '(Faye server not found - progress not sent)'
      end

      private

      def message_body(message)
        { channel: "/#{@channel_id}",
          data: message }.to_json
      end
    end
  end
end
