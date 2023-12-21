# frozen_string_literal: true

# classification.rb

require 'open3'
require 'pry'

module PetAdoption
  module ImageRecognition
    # class Info::Project`
    class Classification
      attr_reader :species

      def initialize
        @script_path = 'app/infrastructure/image_recognition/classification.py'
        @species = ''
      end

      def run(image_path)
        current_output, = run_classification(image_path)
        animal_species(current_output)
      end

      def animal_species(current_output)
        @species = if current_output.match(/'class': '\d+\.(.*?)'/).nil?
                     'hybrid'
                   else
                     current_output.match(/'class': '\d+\.(.*?)'/)[1]
                   end
      end

      def run_classification(image_path)
        current_output, current_status = Open3.capture2("python3 #{@script_path} #{image_path}")

        [current_output, current_status]
      end
    end
  end
end
