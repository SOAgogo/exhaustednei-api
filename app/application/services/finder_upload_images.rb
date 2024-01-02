# frozen_string_literal: true

require 'dry/transaction'

module PetAdoption
  module Services
    # class ImageRecognition`
    class FinderUploadImages
      include Dry::Transaction
      step :validate_input
      step :create_finder_mapper
      step :upload_image
      step :store_upload_record
      step :find_the_vets

      private

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
        finder_mapper = PetAdoption::LossingPets::FinderMapper.new(
          request.except(:location, :file, :number, :distance),
          request[:location]
        )
        input = [finder_mapper, request[:file], request[:number],
                 request[:distance]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def upload_image(input)
        finder_mapper = input[:input][0]
        finder_mapper.upload_image(input[:input][1])
        input = [finder_mapper, input[:input][2], input[:input][3]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def store_upload_record(input)
        finder_mapper = input[:input][0]
        finder_mapper.store_user_info
        input = [finder_mapper, input[:input][1], input[:input][2]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def find_the_vets(input) # rubocop:disable Metrics/AbcSize
        finder_mapper = input[:input][0]

        finder = finder_mapper.build_entity(input[:input][2], input[:input][1])

        return Failure('Sorry, in this moment, there is no vet nearby you') if finder.vet_info.vet_info.empty?

        clinic_result = Response::ClinicRecommendation.new(finder.vet_info.clinic_info,
                                                           finder.take_care_info.instruction)

        Success(Response::ApiResult.new(status: :ok, message: clinic_result))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :bad_request, message: 'Cannot find any clinic nearby'))
      end
    end
  end
end
