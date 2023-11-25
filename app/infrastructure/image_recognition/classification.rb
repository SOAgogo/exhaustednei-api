# frozen_string_literal: true

# classification.rb
require 'pry'
require 'open3'

module PetAdoption
  module ImageRecognition
    # class Info::Project`
    class Classification
      def initialize(uploaded_file)
        @script_path = 'app/infrastructure/image_recognition/classification.py'
        @uploaded_file = uploaded_file
      end

      def run
        run_classification(@script_path, @uploaded_file)
      end

      def run_classification(script_path, uploaded_file)
        output, status = Open3.capture2("python3 #{script_path} #{uploaded_file}")
        [output, status]
      end
    end
  end
end
