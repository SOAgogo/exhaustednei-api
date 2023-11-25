# frozen_string_literal: true

require 'dry/transaction'

module PetAdoption
  module Services
    # class ImageRecognition`
    class ImageRecognition
      include Dry::Transaction
      step :dog_recognition

      private

      def dog_recognition(input)
        output, = PetAdoption::ImageRecognition::Classification.new(input[:uploaded_file]).run
        if output.nil?
          Failure('no recognition output')
        else
          Success(:output)
        end
      rescue StandardError => e
        Failure(e.message)
      end
    end
  end
end
