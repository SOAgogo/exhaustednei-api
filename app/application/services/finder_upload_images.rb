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
      step :create_finder_mapper
      # step :seting_finder_info
      # step :find_the_vets

      private

      PROCESSING_MSG = 'upload success and processing'

      def validate_input(input)
        request = input[:request].call
        request_value = request.value!
        if request_value[:file].nil? || request_value[:number].nil? || request_value[:distance].nil?
          Failure('Please upload a photo and fill in the number of pets and the distance')
        end
        Success(request)
      end

      def create_finder_mapper(input)
        request = input.value!

        Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config).send(request.to_json)
        finder_mapper = PetAdoption::LossingPets::FinderMapper.new(
          request.except(:location, :file, :number, :distance),
          request[:location]
        )
        

        # read the response from cache


        # input = [finder_mapper, request[:file], request[:number], request[:distance]]

        Failure(Response::ApiResult.new(
                  status: :processing,
                  message: PROCESSING_MSG_EP
                ))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: 'system error'))
      end

      # def seting_finder_info(input)
      #   finder_mapper = input[0]
      #   finder_mapper.images_url(input[1])
      #   finder_mapper.image_recoginition
      #   finder_mapper.store_user_info
      #   input = [finder_mapper, input[2], input[3]]

      #   Success(input:)
      # rescue StandardError
      #   Failure(Response::ApiResult.new(status: :internal_error, message: 'system error'))
      # end

      # def find_the_vets(input)
      #   finder_mapper = input[:input][0]

      #   # finder = finder_mapper.build_entity(input[:input][2], input[:input][1])
      #   message = [finder_mapper, input[:input][2], input[:input][1]].to_json
      #   binding.pry

      #   # Messaging::Queue.new(Api.config.SQS_QUEUE_URL).send(message)

      #   if finder.vet_info.clinic_info.empty?
      #     return Failure(Response::ApiResult.new(status: :no_content, message: 'there is no vet nearby you'))
      #   end

      #   clinic_result = Response::ClinicRecommendation.new(finder.vet_info.clinic_info,
      #                                                      finder.take_care_info.instruction)

      #   Success(Response::ApiResult.new(status: :ok, message: clinic_result))
      # rescue StandardError
      #   Failure(Response::ApiResult.new(status: :bad_request, message: 'Cannot find any clinic nearby'))
      # end
    end
  end
end
