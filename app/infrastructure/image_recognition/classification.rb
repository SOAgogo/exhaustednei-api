# frozen_string_literal: true

# classification.rb

require 'open3'
require 'pry'

module PetAdoption
  module ImageRecognition
    # class Info::Project`
    class Classification
      attr_reader :current_file, :other_files_on_s3

      def initialize
        @script_path = 'app/infrastructure/image_recognition/classification.py'
        @current_file = ''
        @other_files_on_s3 = ''
      end

      def image_path(current_file, other_files_on_s3)
        @current_file = current_file
        @other_files_on_s3 = other_files_on_s3
      end

      def run
        # Classification.run_classification
        run_classification
      end

      def run_classification
        current_output, current_status = Open3.capture2("python3 #{@script_path} #{@current_file}")
        other_output, other_status = Open3.capture2("python3 #{@script_path} #{@other_files_on_s3}")
        [current_output, current_status, other_output, other_status]

        # [output, status]
      end
    end
  end
end
