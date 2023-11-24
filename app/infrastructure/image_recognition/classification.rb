# frozen_string_literal: true

# classification.rb

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
        # Get the current working directory
        # Create the absolute path by joining the directory of the current file and the relative file path
        # output, error, status = Open3.capture3("python3 #{script_path} #{uploaded_file}")
        output, = Open3.capture2("python3 #{script_path} #{uploaded_file}")
        output
      end
    end
  end
end
