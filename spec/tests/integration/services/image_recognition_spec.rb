# frozen_string_literal: true

require_relative '../layers/spec_helper'
require_relative '../../../helpers/database_helper'
require 'securerandom'

describe 'Crete image recognition Integration Test' do
  folder_path = './testing_image_recognition'
  file_paths = Dir.glob(File.join(folder_path, '*'))

  describe 'get the correct image recognition results' do
    it 'HAPPY: should return correct dog recognition results' do
      file_paths.each_with_index do |file_path, index|
        output = Services::ImageRecognition.new.call({ uploaded_file: file_path })
        if index == 1
          assert_includes(output.value![:output], 'labrador')
        else
          assert_includes(output.value![:output], 'Alaskan_malamute')
        end
      end
    end
  end
end
