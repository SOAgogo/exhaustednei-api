# frozen_string_literal: true

require 'dry/transaction'

module PetAdoption
  module Services
    # class ImageRecognition`
    class FinderUploadImages
      include Dry::Transaction
      step :create_finder_mapper
      step :upload_image
      step :find_the_vets

      private

      def create_finder_mapper(input)
        finder = PetAdoption::LossingPets::FinderMapper.new(input[:finder_info].except(:location, :file),
                                                            input[:finder_info][:location])

        input = [finder, input[:finder_info][:file]]
        Success(input:)
      rescue StandardError => e
        Failure(e.message)
      end

      def upload_image(input)
        finder = input[:input][0]
        finder.upload_image(input[:input][1])
        Success(finder:)
      rescue StandardError => e
        Failure(e.message)
      end

      def find_the_vets(input)
        finder = input[:finder]
        finder2 = finder.build_entity(50_000, 5)
        binding.pry
        vet_info = finder2.first_contact_vet

        Success(vet_info:)
      rescue StandardError => e
        Failure(e.message)
      end
    end
  end
end
