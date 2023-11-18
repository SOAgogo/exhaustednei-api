# frozen_string_literal: true

# download by command curl

require_relative '../../../spec/spec_helper'
module PetAdoption
  # download file by command curl
  module CurlDownload
    # Using the `curl` command to download the file

    # class FileDownloader`
    class FileDownloader
      attr_reader :request_body

      def initialize
        @request_body = FileDownloader.download_file
      end

      def self.download_file
        system("curl -o #{File.join(DOWNLOAD_PATH)} #{RESOURCE_PATH}")

        # Check the exit status of the command
        if $CHILD_STATUS.success?
          puts 'File downloaded successfully.'
        else
          puts 'Error downloading the file.'
        end
        puts 'parse the json file, it may take a while...'
        JSON.parse(File.read('spec/fixtures/DogCat_results.json'))[0..4000]
      end
    end
  end
end
