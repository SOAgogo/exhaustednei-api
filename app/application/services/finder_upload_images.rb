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
        # binding.pry
        request = input[:request].call
        request_value = request.value!
        if request_value[:file].nil? || request_value[:number].nil? || request_value[:distance].nil?
          Failure('Please upload a photo and fill in the number of pets and the distance')
        end
        Success(request)
      end

      def create_finder_mapper_request(input)
        request = input.value!
        # check value
        # take_care_info, vet_check = cache_check_helper
        # if !take_care_info.nil? && !vet_check.nil?
        #   rsp = representation(take_care_info, vet_check)
        #   return Success(Response::ApiResult.new(status: :ok, message: SUCCESS_MSG, data: rsp))
        # end

        # send to queue
        send_to_queue(request)

        Success(Response::ApiResult.new(status: :processing, message: PROCESSING_MSG))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'system error'))
      end

      # helper function for cache data check
      # def cache_check_helper
      #   cache = PetAdoption::Cache::RedisCache.new(App.config)
      #   resp = [cache.get('take_care_info'), cache.get('vets')]
      #   cache.del('take_care_info')
      #   cache.del('vets')
      #   resp
      # end

      def send_to_queue(request)
        queues = [App.config.QUEUE_1_URL, App.config.QUEUE_2_URL, App.config.QUEUE_3_URL]
        queues.each do |queue_url|
          Messaging::Queue.new(queue_url, App.config).send(request.to_json)
        end
      end

      # def representation(take_care_info, vet_check)
      #   binding.pry
      #   PetAdoption::Representer::VetRecommeandation.new(
      #     PetAdoption::Response::ClinicRecommendation.new
      #   ).from_json(take_care_info, vet_check)
      # end
    end
  end
end
