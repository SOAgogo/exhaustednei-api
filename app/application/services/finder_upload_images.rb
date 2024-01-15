# frozen_string_literal: true

require 'dry/transaction'
require 'pry'

module PetAdoption
  module Services
    # class ImageRecognition`
    class FinderUploadImages
      class Error
        NoVeterinaryFound = Class.new(StandardError)
      end
      include Dry::Transaction
      step :validate_input
      step :create_finder_mapper_request

      private

      PROCESSING_MSG = 'upload success and processing'
      SUCCESS_MSG = 'upload success and get result'

      def validate_input(input)
        request = input[:requested].call
        request_value = request.value!
        if request_value[:file].nil? || request_value[:number].nil? || request_value[:distance].nil?
          Failure('Please upload a photo and fill in the number of pets and the distance')
        end
        Success(input)
      end

      def create_finder_mapper_request(input)
        # request = input.value!

        # send to queue
        send_to_queue(input)

        Success(Response::ApiResult.new(status: :processing,
                                        message: { request_id: input[:request_id],
                                                   msg: PROCESSING_MSG }))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'system error'))
      end

      def send_to_queue(request)
        # queues = [App.config.QUEUE_1_URL, App.config.QUEUE_2_URL, App.config.QUEUE_3_URL]
        queues = [App.config.QUEUE_1_URL, App.config.QUEUE_2_URL]
        queues.each do |queue_url|
          Messaging::Queue.new(queue_url, App.config)
            .send(message(request))
        end
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: e.message))
      end

      def message(request)
        request[:requested].call.value!.merge(request_id: request[:request_id]).to_json
      end
    end
  end
end
