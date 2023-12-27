# frozen_string_literal: true

require 'dry/transaction'

module PetAdoption
  module Services
    # class ImageRecognition`
    class FinderUploadImages
      include Dry::Transaction
      step :create_finder_mapper
      step :upload_image
      step :store_upload_record
      step :find_the_vets

      private

      def create_finder_mapper(input)
        finder_mapper = PetAdoption::LossingPets::FinderMapper.new(input[:finder_info].except(:location, :file, :number),
                                                                   input[:finder_info][:location])

        input = [finder_mapper, input[:finder_info][:file], input[:finder_info][:number]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def upload_image(input)
        finder_mapper = input[:input][0]
        finder_mapper.upload_image(input[:input][1])
        input = [finder_mapper, input[:input][2]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def store_upload_record(input)
        finder_mapper = input[:input][0]
        finder_mapper.store_user_info
        input = [finder_mapper, input[:input][1]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def find_the_vets(input)
        finder_mapper = input[:input][0]
        finder = finder_mapper.build_entity(500_000, input[:input][1])
        Success(finder:)
      rescue StandardError
        Failure('Sorry, in this moment, there is no vet nearby you')
      end
    end
  end
end
