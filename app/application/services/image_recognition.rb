# frozen_string_literal: true

require 'dry/transaction'
require 'pry'

module PetAdoption
  module Services
    # class ImageRecognition`
    class ImageRecognition
      include Dry::Transaction
      step :dog_recognition

      private

      def dog_recognition(input)
        output, status = PetAdoption::ImageRecognition::Classification.new(input[:uploaded_file]).run

        if status.success?
          Success(output:)
        else
          Failure('no recognition output')
        end
      rescue StandardError => e
        Failure(e.message)
      end
    end
  end
end
