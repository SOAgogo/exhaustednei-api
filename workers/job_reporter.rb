# frozen_string_literal: true

require_relative 'progress_publisher'
require 'json'
require 'pry'

module PetAdoptoion
  # Reports job progress to client
  module Background
    # Reports progress to client
    class JobReporter
      def initialize(request_json, config)
        req = JSON.parse(request_json)
        @finder_info = req.except('request_id')
        @publisher = PetAdoption::Background::ProgressPublisher.new(config, req['request_id'])
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
