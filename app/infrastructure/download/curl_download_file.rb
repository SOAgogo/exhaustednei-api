# frozen_string_literal: true

# download by command curl

# FILE_PATH = 'spec/fixtures/DogCat_results.json'
FILE_PATH = 'spec/fixtures/DogCat_results.json'
API_PATH = 'https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL'
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
        system("curl -o #{File.join(FILE_PATH)} #{API_PATH}")

        # Check the exit status of the command
        # if $CHILD_STATUS.success?
        #   puts 'File downloaded successfully.'
        # else
        #   puts 'Error downloading the file.'
        # end
        puts 'parse the json file, it may take a while...'
        JSON.parse(File.read('spec/fixtures/DogCat_results.json'))[0..10]
      end
    end
  end
end
