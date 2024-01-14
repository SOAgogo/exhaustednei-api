# frozen_string_literal: true

require_relative 'progress_publisher'
require 'pry'

module PetAdoptoion
  # Reports job progress to client
  module Background
    # Reports progress to client
    class JobReporter
      def initialize(request_json, config)
        req = JSON.parse(request_json)
        # @token = req[0]
        # @id = req[1]
        @publisher = PetAdoption::Background::ProgressPublisher.new(config, req[2])
      end

      def report(msg)
        @publisher.publish msg
      end

      def report_each_second(seconds, &operation)
        seconds.times do
          sleep(1)
          report(operation.call)
        end
      end
    end
  end
end
